
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 b4 13 00 00       	call   801402 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 f7 13 00 00       	call   80144d <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 60 1c 80 00       	push   $0x801c60
  800088:	e8 8d 04 00 00       	call   80051a <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800097:	eb 2c                	jmp    8000c5 <_main+0x8d>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  800099:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8a 00                	mov    (%eax),%al
  8000a6:	3c ff                	cmp    $0xff,%al
  8000a8:	74 14                	je     8000be <_main+0x86>
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	68 98 1c 80 00       	push   $0x801c98
  8000b2:	6a 1a                	push   $0x1a
  8000b4:	68 c8 1c 80 00       	push   $0x801cc8
  8000b9:	e8 9f 01 00 00       	call   80025d <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000be:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c5:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000cc:	7e cb                	jle    800099 <_main+0x61>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000ce:	e8 7a 13 00 00       	call   80144d <sys_pf_calculate_allocated_pages>
  8000d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d6:	83 f8 0a             	cmp    $0xa,%eax
  8000d9:	74 14                	je     8000ef <_main+0xb7>
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	68 ec 1c 80 00       	push   $0x801cec
  8000e3:	6a 1c                	push   $0x1c
  8000e5:	68 c8 1c 80 00       	push   $0x801cc8
  8000ea:	e8 6e 01 00 00       	call   80025d <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000ef:	e8 0e 13 00 00       	call   801402 <sys_calculate_free_frames>
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	e8 20 13 00 00       	call   80141b <sys_calculate_modified_frames>
  8000fb:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 28 1d 80 00       	push   $0x801d28
  80010d:	6a 1e                	push   $0x1e
  80010f:	68 c8 1c 80 00       	push   $0x801cc8
  800114:	e8 44 01 00 00       	call   80025d <_panic>
	}//consider tables of PF, disk pages

	cprintf("Congratulations: stack pages created, modified and read successfully!\n\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 8c 1d 80 00       	push   $0x801d8c
  800121:	e8 f4 03 00 00       	call   80051a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp


	return;
  800129:	90                   	nop
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800135:	e8 53 15 00 00       	call   80168d <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	01 d0                	add    %edx,%eax
  800146:	c1 e0 06             	shl    $0x6,%eax
  800149:	29 d0                	sub    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800153:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800158:	a1 20 30 80 00       	mov    0x803020,%eax
  80015d:	8a 40 68             	mov    0x68(%eax),%al
  800160:	84 c0                	test   %al,%al
  800162:	74 0d                	je     800171 <libmain+0x42>
		binaryname = myEnv->prog_name;
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	83 c0 68             	add    $0x68,%eax
  80016c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800175:	7e 0a                	jle    800181 <libmain+0x52>
		binaryname = argv[0];
  800177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	e8 a9 fe ff ff       	call   800038 <_main>
  80018f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800192:	e8 03 13 00 00       	call   80149a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 ec 1d 80 00       	push   $0x801dec
  80019f:	e8 76 03 00 00       	call   80051a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	68 14 1e 80 00       	push   $0x801e14
  8001c7:	e8 4e 03 00 00       	call   80051a <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d4:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  8001e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ea:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  8001f0:	51                   	push   %ecx
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	68 3c 1e 80 00       	push   $0x801e3c
  8001f8:	e8 1d 03 00 00       	call   80051a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	50                   	push   %eax
  80020f:	68 94 1e 80 00       	push   $0x801e94
  800214:	e8 01 03 00 00       	call   80051a <cprintf>
  800219:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	68 ec 1d 80 00       	push   $0x801dec
  800224:	e8 f1 02 00 00       	call   80051a <cprintf>
  800229:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022c:	e8 83 12 00 00       	call   8014b4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800231:	e8 19 00 00 00       	call   80024f <exit>
}
  800236:	90                   	nop
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	6a 00                	push   $0x0
  800244:	e8 10 14 00 00       	call   801659 <sys_destroy_env>
  800249:	83 c4 10             	add    $0x10,%esp
}
  80024c:	90                   	nop
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <exit>:

void
exit(void)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800255:	e8 65 14 00 00       	call   8016bf <sys_exit_env>
}
  80025a:	90                   	nop
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800263:	8d 45 10             	lea    0x10(%ebp),%eax
  800266:	83 c0 04             	add    $0x4,%eax
  800269:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026c:	a1 18 31 80 00       	mov    0x803118,%eax
  800271:	85 c0                	test   %eax,%eax
  800273:	74 16                	je     80028b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800275:	a1 18 31 80 00       	mov    0x803118,%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 a8 1e 80 00       	push   $0x801ea8
  800283:	e8 92 02 00 00       	call   80051a <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80028b:	a1 00 30 80 00       	mov    0x803000,%eax
  800290:	ff 75 0c             	pushl  0xc(%ebp)
  800293:	ff 75 08             	pushl  0x8(%ebp)
  800296:	50                   	push   %eax
  800297:	68 ad 1e 80 00       	push   $0x801ead
  80029c:	e8 79 02 00 00       	call   80051a <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ad:	50                   	push   %eax
  8002ae:	e8 fc 01 00 00       	call   8004af <vcprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	6a 00                	push   $0x0
  8002bb:	68 c9 1e 80 00       	push   $0x801ec9
  8002c0:	e8 ea 01 00 00       	call   8004af <vcprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c8:	e8 82 ff ff ff       	call   80024f <exit>

	// should not return here
	while (1) ;
  8002cd:	eb fe                	jmp    8002cd <_panic+0x70>

008002cf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e3:	39 c2                	cmp    %eax,%edx
  8002e5:	74 14                	je     8002fb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	68 cc 1e 80 00       	push   $0x801ecc
  8002ef:	6a 26                	push   $0x26
  8002f1:	68 18 1f 80 00       	push   $0x801f18
  8002f6:	e8 62 ff ff ff       	call   80025d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800302:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800309:	e9 c5 00 00 00       	jmp    8003d3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80030e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800318:	8b 45 08             	mov    0x8(%ebp),%eax
  80031b:	01 d0                	add    %edx,%eax
  80031d:	8b 00                	mov    (%eax),%eax
  80031f:	85 c0                	test   %eax,%eax
  800321:	75 08                	jne    80032b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800323:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800326:	e9 a5 00 00 00       	jmp    8003d0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80032b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800332:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800339:	eb 69                	jmp    8003a4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80033b:	a1 20 30 80 00       	mov    0x803020,%eax
  800340:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800349:	89 d0                	mov    %edx,%eax
  80034b:	01 c0                	add    %eax,%eax
  80034d:	01 d0                	add    %edx,%eax
  80034f:	c1 e0 03             	shl    $0x3,%eax
  800352:	01 c8                	add    %ecx,%eax
  800354:	8a 40 04             	mov    0x4(%eax),%al
  800357:	84 c0                	test   %al,%al
  800359:	75 46                	jne    8003a1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80035b:	a1 20 30 80 00       	mov    0x803020,%eax
  800360:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8b 00                	mov    (%eax),%eax
  800376:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800379:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800381:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	01 c8                	add    %ecx,%eax
  800392:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800394:	39 c2                	cmp    %eax,%edx
  800396:	75 09                	jne    8003a1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800398:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039f:	eb 15                	jmp    8003b6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a1:	ff 45 e8             	incl   -0x18(%ebp)
  8003a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a9:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8003af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	77 85                	ja     80033b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ba:	75 14                	jne    8003d0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 24 1f 80 00       	push   $0x801f24
  8003c4:	6a 3a                	push   $0x3a
  8003c6:	68 18 1f 80 00       	push   $0x801f18
  8003cb:	e8 8d fe ff ff       	call   80025d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003d0:	ff 45 f0             	incl   -0x10(%ebp)
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d9:	0f 8c 2f ff ff ff    	jl     80030e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ed:	eb 26                	jmp    800415 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f4:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8003fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003fd:	89 d0                	mov    %edx,%eax
  8003ff:	01 c0                	add    %eax,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	c1 e0 03             	shl    $0x3,%eax
  800406:	01 c8                	add    %ecx,%eax
  800408:	8a 40 04             	mov    0x4(%eax),%al
  80040b:	3c 01                	cmp    $0x1,%al
  80040d:	75 03                	jne    800412 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80040f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e0             	incl   -0x20(%ebp)
  800415:	a1 20 30 80 00       	mov    0x803020,%eax
  80041a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800423:	39 c2                	cmp    %eax,%edx
  800425:	77 c8                	ja     8003ef <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80042d:	74 14                	je     800443 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	68 78 1f 80 00       	push   $0x801f78
  800437:	6a 44                	push   $0x44
  800439:	68 18 1f 80 00       	push   $0x801f18
  80043e:	e8 1a fe ff ff       	call   80025d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800443:	90                   	nop
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 48 01             	lea    0x1(%eax),%ecx
  800454:	8b 55 0c             	mov    0xc(%ebp),%edx
  800457:	89 0a                	mov    %ecx,(%edx)
  800459:	8b 55 08             	mov    0x8(%ebp),%edx
  80045c:	88 d1                	mov    %dl,%cl
  80045e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800461:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046f:	75 2c                	jne    80049d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800471:	a0 24 30 80 00       	mov    0x803024,%al
  800476:	0f b6 c0             	movzbl %al,%eax
  800479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047c:	8b 12                	mov    (%edx),%edx
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	8b 55 0c             	mov    0xc(%ebp),%edx
  800483:	83 c2 08             	add    $0x8,%edx
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	50                   	push   %eax
  80048a:	51                   	push   %ecx
  80048b:	52                   	push   %edx
  80048c:	e8 b0 0e 00 00       	call   801341 <sys_cputs>
  800491:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800494:	8b 45 0c             	mov    0xc(%ebp),%eax
  800497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a0:	8b 40 04             	mov    0x4(%eax),%eax
  8004a3:	8d 50 01             	lea    0x1(%eax),%edx
  8004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ac:	90                   	nop
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004bf:	00 00 00 
	b.cnt = 0;
  8004c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004c9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d8:	50                   	push   %eax
  8004d9:	68 46 04 80 00       	push   $0x800446
  8004de:	e8 11 02 00 00       	call   8006f4 <vprintfmt>
  8004e3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004e6:	a0 24 30 80 00       	mov    0x803024,%al
  8004eb:	0f b6 c0             	movzbl %al,%eax
  8004ee:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	50                   	push   %eax
  8004f8:	52                   	push   %edx
  8004f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ff:	83 c0 08             	add    $0x8,%eax
  800502:	50                   	push   %eax
  800503:	e8 39 0e 00 00       	call   801341 <sys_cputs>
  800508:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80050b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800512:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <cprintf>:

int cprintf(const char *fmt, ...) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800520:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800527:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	ff 75 f4             	pushl  -0xc(%ebp)
  800536:	50                   	push   %eax
  800537:	e8 73 ff ff ff       	call   8004af <vcprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800542:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80054d:	e8 48 0f 00 00       	call   80149a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800552:	8d 45 0c             	lea    0xc(%ebp),%eax
  800555:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	ff 75 f4             	pushl  -0xc(%ebp)
  800561:	50                   	push   %eax
  800562:	e8 48 ff ff ff       	call   8004af <vcprintf>
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80056d:	e8 42 0f 00 00       	call   8014b4 <sys_enable_interrupt>
	return cnt;
  800572:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	53                   	push   %ebx
  80057b:	83 ec 14             	sub    $0x14,%esp
  80057e:	8b 45 10             	mov    0x10(%ebp),%eax
  800581:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058a:	8b 45 18             	mov    0x18(%ebp),%eax
  80058d:	ba 00 00 00 00       	mov    $0x0,%edx
  800592:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800595:	77 55                	ja     8005ec <printnum+0x75>
  800597:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059a:	72 05                	jb     8005a1 <printnum+0x2a>
  80059c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059f:	77 4b                	ja     8005ec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	52                   	push   %edx
  8005b0:	50                   	push   %eax
  8005b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b7:	e8 28 14 00 00       	call   8019e4 <__udivdi3>
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	83 ec 04             	sub    $0x4,%esp
  8005c2:	ff 75 20             	pushl  0x20(%ebp)
  8005c5:	53                   	push   %ebx
  8005c6:	ff 75 18             	pushl  0x18(%ebp)
  8005c9:	52                   	push   %edx
  8005ca:	50                   	push   %eax
  8005cb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ce:	ff 75 08             	pushl  0x8(%ebp)
  8005d1:	e8 a1 ff ff ff       	call   800577 <printnum>
  8005d6:	83 c4 20             	add    $0x20,%esp
  8005d9:	eb 1a                	jmp    8005f5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	ff 75 20             	pushl  0x20(%ebp)
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	ff d0                	call   *%eax
  8005e9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ec:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f3:	7f e6                	jg     8005db <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800600:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800603:	53                   	push   %ebx
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	e8 e8 14 00 00       	call   801af4 <__umoddi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	05 f4 21 80 00       	add    $0x8021f4,%eax
  800614:	8a 00                	mov    (%eax),%al
  800616:	0f be c0             	movsbl %al,%eax
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	ff 75 0c             	pushl  0xc(%ebp)
  80061f:	50                   	push   %eax
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	ff d0                	call   *%eax
  800625:	83 c4 10             	add    $0x10,%esp
}
  800628:	90                   	nop
  800629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800631:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800635:	7e 1c                	jle    800653 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	8d 50 08             	lea    0x8(%eax),%edx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	89 10                	mov    %edx,(%eax)
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	83 e8 08             	sub    $0x8,%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	eb 40                	jmp    800693 <getuint+0x65>
	else if (lflag)
  800653:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800657:	74 1e                	je     800677 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	8d 50 04             	lea    0x4(%eax),%edx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	89 10                	mov    %edx,(%eax)
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	83 e8 04             	sub    $0x4,%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	ba 00 00 00 00       	mov    $0x0,%edx
  800675:	eb 1c                	jmp    800693 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	8d 50 04             	lea    0x4(%eax),%edx
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	89 10                	mov    %edx,(%eax)
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	83 e8 04             	sub    $0x4,%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800693:	5d                   	pop    %ebp
  800694:	c3                   	ret    

00800695 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800698:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069c:	7e 1c                	jle    8006ba <getint+0x25>
		return va_arg(*ap, long long);
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	8d 50 08             	lea    0x8(%eax),%edx
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	89 10                	mov    %edx,(%eax)
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	83 e8 08             	sub    $0x8,%eax
  8006b3:	8b 50 04             	mov    0x4(%eax),%edx
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	eb 38                	jmp    8006f2 <getint+0x5d>
	else if (lflag)
  8006ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006be:	74 1a                	je     8006da <getint+0x45>
		return va_arg(*ap, long);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	8d 50 04             	lea    0x4(%eax),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	89 10                	mov    %edx,(%eax)
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	99                   	cltd   
  8006d8:	eb 18                	jmp    8006f2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	89 10                	mov    %edx,(%eax)
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	83 e8 04             	sub    $0x4,%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	99                   	cltd   
}
  8006f2:	5d                   	pop    %ebp
  8006f3:	c3                   	ret    

008006f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	56                   	push   %esi
  8006f8:	53                   	push   %ebx
  8006f9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fc:	eb 17                	jmp    800715 <vprintfmt+0x21>
			if (ch == '\0')
  8006fe:	85 db                	test   %ebx,%ebx
  800700:	0f 84 af 03 00 00    	je     800ab5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	53                   	push   %ebx
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	8b 45 10             	mov    0x10(%ebp),%eax
  800718:	8d 50 01             	lea    0x1(%eax),%edx
  80071b:	89 55 10             	mov    %edx,0x10(%ebp)
  80071e:	8a 00                	mov    (%eax),%al
  800720:	0f b6 d8             	movzbl %al,%ebx
  800723:	83 fb 25             	cmp    $0x25,%ebx
  800726:	75 d6                	jne    8006fe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800728:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80072c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800733:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800741:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800748:	8b 45 10             	mov    0x10(%ebp),%eax
  80074b:	8d 50 01             	lea    0x1(%eax),%edx
  80074e:	89 55 10             	mov    %edx,0x10(%ebp)
  800751:	8a 00                	mov    (%eax),%al
  800753:	0f b6 d8             	movzbl %al,%ebx
  800756:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800759:	83 f8 55             	cmp    $0x55,%eax
  80075c:	0f 87 2b 03 00 00    	ja     800a8d <vprintfmt+0x399>
  800762:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  800769:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80076b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80076f:	eb d7                	jmp    800748 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800771:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800775:	eb d1                	jmp    800748 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800777:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80077e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800781:	89 d0                	mov    %edx,%eax
  800783:	c1 e0 02             	shl    $0x2,%eax
  800786:	01 d0                	add    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d8                	add    %ebx,%eax
  80078c:	83 e8 30             	sub    $0x30,%eax
  80078f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800792:	8b 45 10             	mov    0x10(%ebp),%eax
  800795:	8a 00                	mov    (%eax),%al
  800797:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079a:	83 fb 2f             	cmp    $0x2f,%ebx
  80079d:	7e 3e                	jle    8007dd <vprintfmt+0xe9>
  80079f:	83 fb 39             	cmp    $0x39,%ebx
  8007a2:	7f 39                	jg     8007dd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a7:	eb d5                	jmp    80077e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	83 c0 04             	add    $0x4,%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 e8 04             	sub    $0x4,%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007bd:	eb 1f                	jmp    8007de <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c3:	79 83                	jns    800748 <vprintfmt+0x54>
				width = 0;
  8007c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007cc:	e9 77 ff ff ff       	jmp    800748 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007d8:	e9 6b ff ff ff       	jmp    800748 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007dd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	0f 89 60 ff ff ff    	jns    800748 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f5:	e9 4e ff ff ff       	jmp    800748 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007fd:	e9 46 ff ff ff       	jmp    800748 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 c0 04             	add    $0x4,%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 e8 04             	sub    $0x4,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			break;
  800822:	e9 89 02 00 00       	jmp    800ab0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 e8 04             	sub    $0x4,%eax
  800836:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800838:	85 db                	test   %ebx,%ebx
  80083a:	79 02                	jns    80083e <vprintfmt+0x14a>
				err = -err;
  80083c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80083e:	83 fb 64             	cmp    $0x64,%ebx
  800841:	7f 0b                	jg     80084e <vprintfmt+0x15a>
  800843:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  80084a:	85 f6                	test   %esi,%esi
  80084c:	75 19                	jne    800867 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80084e:	53                   	push   %ebx
  80084f:	68 05 22 80 00       	push   $0x802205
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 5e 02 00 00       	call   800abd <printfmt>
  80085f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800862:	e9 49 02 00 00       	jmp    800ab0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800867:	56                   	push   %esi
  800868:	68 0e 22 80 00       	push   $0x80220e
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 45 02 00 00       	call   800abd <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			break;
  80087b:	e9 30 02 00 00       	jmp    800ab0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 c0 04             	add    $0x4,%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 e8 04             	sub    $0x4,%eax
  80088f:	8b 30                	mov    (%eax),%esi
  800891:	85 f6                	test   %esi,%esi
  800893:	75 05                	jne    80089a <vprintfmt+0x1a6>
				p = "(null)";
  800895:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  80089a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089e:	7e 6d                	jle    80090d <vprintfmt+0x219>
  8008a0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a4:	74 67                	je     80090d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	50                   	push   %eax
  8008ad:	56                   	push   %esi
  8008ae:	e8 0c 03 00 00       	call   800bbf <strnlen>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008b9:	eb 16                	jmp    8008d1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008bb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	50                   	push   %eax
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ce:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d5:	7f e4                	jg     8008bb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d7:	eb 34                	jmp    80090d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008dd:	74 1c                	je     8008fb <vprintfmt+0x207>
  8008df:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e2:	7e 05                	jle    8008e9 <vprintfmt+0x1f5>
  8008e4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e7:	7e 12                	jle    8008fb <vprintfmt+0x207>
					putch('?', putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	6a 3f                	push   $0x3f
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	ff d0                	call   *%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	eb 0f                	jmp    80090a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	53                   	push   %ebx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090a:	ff 4d e4             	decl   -0x1c(%ebp)
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	8d 70 01             	lea    0x1(%eax),%esi
  800912:	8a 00                	mov    (%eax),%al
  800914:	0f be d8             	movsbl %al,%ebx
  800917:	85 db                	test   %ebx,%ebx
  800919:	74 24                	je     80093f <vprintfmt+0x24b>
  80091b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091f:	78 b8                	js     8008d9 <vprintfmt+0x1e5>
  800921:	ff 4d e0             	decl   -0x20(%ebp)
  800924:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800928:	79 af                	jns    8008d9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092a:	eb 13                	jmp    80093f <vprintfmt+0x24b>
				putch(' ', putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	6a 20                	push   $0x20
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	ff d0                	call   *%eax
  800939:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093c:	ff 4d e4             	decl   -0x1c(%ebp)
  80093f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800943:	7f e7                	jg     80092c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800945:	e9 66 01 00 00       	jmp    800ab0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 e8             	pushl  -0x18(%ebp)
  800950:	8d 45 14             	lea    0x14(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	e8 3c fd ff ff       	call   800695 <getint>
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800968:	85 d2                	test   %edx,%edx
  80096a:	79 23                	jns    80098f <vprintfmt+0x29b>
				putch('-', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 2d                	push   $0x2d
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80097c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800982:	f7 d8                	neg    %eax
  800984:	83 d2 00             	adc    $0x0,%edx
  800987:	f7 da                	neg    %edx
  800989:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80098f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800996:	e9 bc 00 00 00       	jmp    800a57 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 84 fc ff ff       	call   80062e <getuint>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ba:	e9 98 00 00 00       	jmp    800a57 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	6a 58                	push   $0x58
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 58                	push   $0x58
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			break;
  8009ef:	e9 bc 00 00 00       	jmp    800ab0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 30                	push   $0x30
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 78                	push   $0x78
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 e8 04             	sub    $0x4,%eax
  800a23:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a2f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a36:	eb 1f                	jmp    800a57 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a41:	50                   	push   %eax
  800a42:	e8 e7 fb ff ff       	call   80062e <getuint>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a57:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a5e:	83 ec 04             	sub    $0x4,%esp
  800a61:	52                   	push   %edx
  800a62:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a65:	50                   	push   %eax
  800a66:	ff 75 f4             	pushl  -0xc(%ebp)
  800a69:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	e8 00 fb ff ff       	call   800577 <printnum>
  800a77:	83 c4 20             	add    $0x20,%esp
			break;
  800a7a:	eb 34                	jmp    800ab0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	ff d0                	call   *%eax
  800a88:	83 c4 10             	add    $0x10,%esp
			break;
  800a8b:	eb 23                	jmp    800ab0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	6a 25                	push   $0x25
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a9d:	ff 4d 10             	decl   0x10(%ebp)
  800aa0:	eb 03                	jmp    800aa5 <vprintfmt+0x3b1>
  800aa2:	ff 4d 10             	decl   0x10(%ebp)
  800aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa8:	48                   	dec    %eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	3c 25                	cmp    $0x25,%al
  800aad:	75 f3                	jne    800aa2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aaf:	90                   	nop
		}
	}
  800ab0:	e9 47 fc ff ff       	jmp    8006fc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ab5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad2:	50                   	push   %eax
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	ff 75 08             	pushl  0x8(%ebp)
  800ad9:	e8 16 fc ff ff       	call   8006f4 <vprintfmt>
  800ade:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae1:	90                   	nop
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 40 08             	mov    0x8(%eax),%eax
  800aed:	8d 50 01             	lea    0x1(%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	8b 10                	mov    (%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8b 40 04             	mov    0x4(%eax),%eax
  800b01:	39 c2                	cmp    %eax,%edx
  800b03:	73 12                	jae    800b17 <sprintputch+0x33>
		*b->buf++ = ch;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	89 0a                	mov    %ecx,(%edx)
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	88 10                	mov    %dl,(%eax)
}
  800b17:	90                   	nop
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	01 d0                	add    %edx,%eax
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b3f:	74 06                	je     800b47 <vsnprintf+0x2d>
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	7f 07                	jg     800b4e <vsnprintf+0x34>
		return -E_INVAL;
  800b47:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4c:	eb 20                	jmp    800b6e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b4e:	ff 75 14             	pushl  0x14(%ebp)
  800b51:	ff 75 10             	pushl  0x10(%ebp)
  800b54:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b57:	50                   	push   %eax
  800b58:	68 e4 0a 80 00       	push   $0x800ae4
  800b5d:	e8 92 fb ff ff       	call   8006f4 <vprintfmt>
  800b62:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b76:	8d 45 10             	lea    0x10(%ebp),%eax
  800b79:	83 c0 04             	add    $0x4,%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	50                   	push   %eax
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	ff 75 08             	pushl  0x8(%ebp)
  800b8c:	e8 89 ff ff ff       	call   800b1a <vsnprintf>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba9:	eb 06                	jmp    800bb1 <strlen+0x15>
		n++;
  800bab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bae:	ff 45 08             	incl   0x8(%ebp)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8a 00                	mov    (%eax),%al
  800bb6:	84 c0                	test   %al,%al
  800bb8:	75 f1                	jne    800bab <strlen+0xf>
		n++;
	return n;
  800bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcc:	eb 09                	jmp    800bd7 <strnlen+0x18>
		n++;
  800bce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd1:	ff 45 08             	incl   0x8(%ebp)
  800bd4:	ff 4d 0c             	decl   0xc(%ebp)
  800bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdb:	74 09                	je     800be6 <strnlen+0x27>
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e8                	jne    800bce <strnlen+0xf>
		n++;
	return n;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf7:	90                   	nop
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0a:	8a 12                	mov    (%edx),%dl
  800c0c:	88 10                	mov    %dl,(%eax)
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	84 c0                	test   %al,%al
  800c12:	75 e4                	jne    800bf8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 1f                	jmp    800c4d <strncpy+0x34>
		*dst++ = *src;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 08             	mov    %edx,0x8(%ebp)
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	8a 12                	mov    (%edx),%dl
  800c3c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	74 03                	je     800c4a <strncpy+0x31>
			src++;
  800c47:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4a:	ff 45 fc             	incl   -0x4(%ebp)
  800c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c50:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c53:	72 d9                	jb     800c2e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	74 30                	je     800c9c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c6c:	eb 16                	jmp    800c84 <strlcpy+0x2a>
			*dst++ = *src++;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 08             	mov    %edx,0x8(%ebp)
  800c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c80:	8a 12                	mov    (%edx),%dl
  800c82:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c84:	ff 4d 10             	decl   0x10(%ebp)
  800c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8b:	74 09                	je     800c96 <strlcpy+0x3c>
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 d8                	jne    800c6e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	29 c2                	sub    %eax,%edx
  800ca4:	89 d0                	mov    %edx,%eax
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cab:	eb 06                	jmp    800cb3 <strcmp+0xb>
		p++, q++;
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	74 0e                	je     800cca <strcmp+0x22>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 10                	mov    (%eax),%dl
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	38 c2                	cmp    %al,%dl
  800cc8:	74 e3                	je     800cad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 d0             	movzbl %al,%edx
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	29 c2                	sub    %eax,%edx
  800cdc:	89 d0                	mov    %edx,%eax
}
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce3:	eb 09                	jmp    800cee <strncmp+0xe>
		n--, p++, q++;
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf2:	74 17                	je     800d0b <strncmp+0x2b>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	84 c0                	test   %al,%al
  800cfb:	74 0e                	je     800d0b <strncmp+0x2b>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 10                	mov    (%eax),%dl
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	38 c2                	cmp    %al,%dl
  800d09:	74 da                	je     800ce5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0f:	75 07                	jne    800d18 <strncmp+0x38>
		return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	eb 14                	jmp    800d2c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	29 c2                	sub    %eax,%edx
  800d2a:	89 d0                	mov    %edx,%eax
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3a:	eb 12                	jmp    800d4e <strchr+0x20>
		if (*s == c)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d44:	75 05                	jne    800d4b <strchr+0x1d>
			return (char *) s;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	eb 11                	jmp    800d5c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	75 e5                	jne    800d3c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6a:	eb 0d                	jmp    800d79 <strfind+0x1b>
		if (*s == c)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d74:	74 0e                	je     800d84 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 ea                	jne    800d6c <strfind+0xe>
  800d82:	eb 01                	jmp    800d85 <strfind+0x27>
		if (*s == c)
			break;
  800d84:	90                   	nop
	return (char *) s;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d9c:	eb 0e                	jmp    800dac <memset+0x22>
		*p++ = c;
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dac:	ff 4d f8             	decl   -0x8(%ebp)
  800daf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db3:	79 e9                	jns    800d9e <memset+0x14>
		*p++ = c;

	return v;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dcc:	eb 16                	jmp    800de4 <memcpy+0x2a>
		*d++ = *s++;
  800dce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ddd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de0:	8a 12                	mov    (%edx),%dl
  800de2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dea:	89 55 10             	mov    %edx,0x10(%ebp)
  800ded:	85 c0                	test   %eax,%eax
  800def:	75 dd                	jne    800dce <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0e:	73 50                	jae    800e60 <memmove+0x6a>
  800e10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	01 d0                	add    %edx,%eax
  800e18:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1b:	76 43                	jbe    800e60 <memmove+0x6a>
		s += n;
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e29:	eb 10                	jmp    800e3b <memmove+0x45>
			*--d = *--s;
  800e2b:	ff 4d f8             	decl   -0x8(%ebp)
  800e2e:	ff 4d fc             	decl   -0x4(%ebp)
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	8a 10                	mov    (%eax),%dl
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 e3                	jne    800e2b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e48:	eb 23                	jmp    800e6d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4d:	8d 50 01             	lea    0x1(%eax),%edx
  800e50:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e59:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e5c:	8a 12                	mov    (%edx),%dl
  800e5e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e66:	89 55 10             	mov    %edx,0x10(%ebp)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	75 dd                	jne    800e4a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e84:	eb 2a                	jmp    800eb0 <memcmp+0x3e>
		if (*s1 != *s2)
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	8a 10                	mov    (%eax),%dl
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	38 c2                	cmp    %al,%dl
  800e92:	74 16                	je     800eaa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	0f b6 d0             	movzbl %al,%edx
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	0f b6 c0             	movzbl %al,%eax
  800ea4:	29 c2                	sub    %eax,%edx
  800ea6:	89 d0                	mov    %edx,%eax
  800ea8:	eb 18                	jmp    800ec2 <memcmp+0x50>
		s1++, s2++;
  800eaa:	ff 45 fc             	incl   -0x4(%ebp)
  800ead:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 c9                	jne    800e86 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	01 d0                	add    %edx,%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed5:	eb 15                	jmp    800eec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 d0             	movzbl %al,%edx
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	0f b6 c0             	movzbl %al,%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	74 0d                	je     800ef6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef2:	72 e3                	jb     800ed7 <memfind+0x13>
  800ef4:	eb 01                	jmp    800ef7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ef6:	90                   	nop
	return (void *) s;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f10:	eb 03                	jmp    800f15 <strtol+0x19>
		s++;
  800f12:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 20                	cmp    $0x20,%al
  800f1c:	74 f4                	je     800f12 <strtol+0x16>
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 09                	cmp    $0x9,%al
  800f25:	74 eb                	je     800f12 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 2b                	cmp    $0x2b,%al
  800f2e:	75 05                	jne    800f35 <strtol+0x39>
		s++;
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	eb 13                	jmp    800f48 <strtol+0x4c>
	else if (*s == '-')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 2d                	cmp    $0x2d,%al
  800f3c:	75 0a                	jne    800f48 <strtol+0x4c>
		s++, neg = 1;
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 06                	je     800f54 <strtol+0x58>
  800f4e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f52:	75 20                	jne    800f74 <strtol+0x78>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	3c 30                	cmp    $0x30,%al
  800f5b:	75 17                	jne    800f74 <strtol+0x78>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	40                   	inc    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 78                	cmp    $0x78,%al
  800f65:	75 0d                	jne    800f74 <strtol+0x78>
		s += 2, base = 16;
  800f67:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f6b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f72:	eb 28                	jmp    800f9c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	75 15                	jne    800f8f <strtol+0x93>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 30                	cmp    $0x30,%al
  800f81:	75 0c                	jne    800f8f <strtol+0x93>
		s++, base = 8;
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f8d:	eb 0d                	jmp    800f9c <strtol+0xa0>
	else if (base == 0)
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	75 07                	jne    800f9c <strtol+0xa0>
		base = 10;
  800f95:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3c 2f                	cmp    $0x2f,%al
  800fa3:	7e 19                	jle    800fbe <strtol+0xc2>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3c 39                	cmp    $0x39,%al
  800fac:	7f 10                	jg     800fbe <strtol+0xc2>
			dig = *s - '0';
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f be c0             	movsbl %al,%eax
  800fb6:	83 e8 30             	sub    $0x30,%eax
  800fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbc:	eb 42                	jmp    801000 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 60                	cmp    $0x60,%al
  800fc5:	7e 19                	jle    800fe0 <strtol+0xe4>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	3c 7a                	cmp    $0x7a,%al
  800fce:	7f 10                	jg     800fe0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	0f be c0             	movsbl %al,%eax
  800fd8:	83 e8 57             	sub    $0x57,%eax
  800fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fde:	eb 20                	jmp    801000 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 40                	cmp    $0x40,%al
  800fe7:	7e 39                	jle    801022 <strtol+0x126>
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 5a                	cmp    $0x5a,%al
  800ff0:	7f 30                	jg     801022 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f be c0             	movsbl %al,%eax
  800ffa:	83 e8 37             	sub    $0x37,%eax
  800ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801003:	3b 45 10             	cmp    0x10(%ebp),%eax
  801006:	7d 19                	jge    801021 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801012:	89 c2                	mov    %eax,%edx
  801014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80101c:	e9 7b ff ff ff       	jmp    800f9c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801021:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801022:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801026:	74 08                	je     801030 <strtol+0x134>
		*endptr = (char *) s;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801030:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801034:	74 07                	je     80103d <strtol+0x141>
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	f7 d8                	neg    %eax
  80103b:	eb 03                	jmp    801040 <strtol+0x144>
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <ltostr>:

void
ltostr(long value, char *str)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80104f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105a:	79 13                	jns    80106f <ltostr+0x2d>
	{
		neg = 1;
  80105c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801069:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80106c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801077:	99                   	cltd   
  801078:	f7 f9                	idiv   %ecx
  80107a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801090:	83 c2 30             	add    $0x30,%edx
  801093:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801095:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801098:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109d:	f7 e9                	imul   %ecx
  80109f:	c1 fa 02             	sar    $0x2,%edx
  8010a2:	89 c8                	mov    %ecx,%eax
  8010a4:	c1 f8 1f             	sar    $0x1f,%eax
  8010a7:	29 c2                	sub    %eax,%edx
  8010a9:	89 d0                	mov    %edx,%eax
  8010ab:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	c1 e0 02             	shl    $0x2,%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	01 c0                	add    %eax,%eax
  8010cb:	29 c1                	sub    %eax,%ecx
  8010cd:	89 ca                	mov    %ecx,%edx
  8010cf:	85 d2                	test   %edx,%edx
  8010d1:	75 9c                	jne    80106f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	48                   	dec    %eax
  8010de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e5:	74 3d                	je     801124 <ltostr+0xe2>
		start = 1 ;
  8010e7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ee:	eb 34                	jmp    801124 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	01 c2                	add    %eax,%edx
  801105:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801111:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	01 c2                	add    %eax,%edx
  801119:	8a 45 eb             	mov    -0x15(%ebp),%al
  80111c:	88 02                	mov    %al,(%edx)
		start++ ;
  80111e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801121:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112a:	7c c4                	jl     8010f0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80112c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801137:	90                   	nop
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801140:	ff 75 08             	pushl  0x8(%ebp)
  801143:	e8 54 fa ff ff       	call   800b9c <strlen>
  801148:	83 c4 04             	add    $0x4,%esp
  80114b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80114e:	ff 75 0c             	pushl  0xc(%ebp)
  801151:	e8 46 fa ff ff       	call   800b9c <strlen>
  801156:	83 c4 04             	add    $0x4,%esp
  801159:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80115c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116a:	eb 17                	jmp    801183 <strcconcat+0x49>
		final[s] = str1[s] ;
  80116c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 c2                	add    %eax,%edx
  801174:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	01 c8                	add    %ecx,%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801180:	ff 45 fc             	incl   -0x4(%ebp)
  801183:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801186:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801189:	7c e1                	jl     80116c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80118b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801192:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801199:	eb 1f                	jmp    8011ba <strcconcat+0x80>
		final[s++] = str2[i] ;
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	8d 50 01             	lea    0x1(%eax),%edx
  8011a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a4:	89 c2                	mov    %eax,%edx
  8011a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a9:	01 c2                	add    %eax,%edx
  8011ab:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	01 c8                	add    %ecx,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011b7:	ff 45 f8             	incl   -0x8(%ebp)
  8011ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c0:	7c d9                	jl     80119b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c6 00 00             	movb   $0x0,(%eax)
}
  8011cd:	90                   	nop
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011df:	8b 00                	mov    (%eax),%eax
  8011e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 d0                	add    %edx,%eax
  8011ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f3:	eb 0c                	jmp    801201 <strsplit+0x31>
			*string++ = 0;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8d 50 01             	lea    0x1(%eax),%edx
  8011fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8011fe:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	84 c0                	test   %al,%al
  801208:	74 18                	je     801222 <strsplit+0x52>
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	0f be c0             	movsbl %al,%eax
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	e8 13 fb ff ff       	call   800d2e <strchr>
  80121b:	83 c4 08             	add    $0x8,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	75 d3                	jne    8011f5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	84 c0                	test   %al,%al
  801229:	74 5a                	je     801285 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80122b:	8b 45 14             	mov    0x14(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	83 f8 0f             	cmp    $0xf,%eax
  801233:	75 07                	jne    80123c <strsplit+0x6c>
		{
			return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
  80123a:	eb 66                	jmp    8012a2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	8d 48 01             	lea    0x1(%eax),%ecx
  801244:	8b 55 14             	mov    0x14(%ebp),%edx
  801247:	89 0a                	mov    %ecx,(%edx)
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 c2                	add    %eax,%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125a:	eb 03                	jmp    80125f <strsplit+0x8f>
			string++;
  80125c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	84 c0                	test   %al,%al
  801266:	74 8b                	je     8011f3 <strsplit+0x23>
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	0f be c0             	movsbl %al,%eax
  801270:	50                   	push   %eax
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	e8 b5 fa ff ff       	call   800d2e <strchr>
  801279:	83 c4 08             	add    $0x8,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	74 dc                	je     80125c <strsplit+0x8c>
			string++;
	}
  801280:	e9 6e ff ff ff       	jmp    8011f3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801285:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	8b 00                	mov    (%eax),%eax
  80128b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	01 d0                	add    %edx,%eax
  801297:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80129d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b1:	eb 4c                	jmp    8012ff <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8012b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 40                	cmp    $0x40,%al
  8012bf:	7e 27                	jle    8012e8 <str2lower+0x44>
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 5a                	cmp    $0x5a,%al
  8012cd:	7f 19                	jg     8012e8 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  8012cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	01 ca                	add    %ecx,%edx
  8012df:	8a 12                	mov    (%edx),%dl
  8012e1:	83 c2 20             	add    $0x20,%edx
  8012e4:	88 10                	mov    %dl,(%eax)
  8012e6:	eb 14                	jmp    8012fc <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  8012e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	01 c2                	add    %eax,%edx
  8012f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	01 c8                	add    %ecx,%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012fc:	ff 45 fc             	incl   -0x4(%ebp)
  8012ff:	ff 75 0c             	pushl  0xc(%ebp)
  801302:	e8 95 f8 ff ff       	call   800b9c <strlen>
  801307:	83 c4 04             	add    $0x4,%esp
  80130a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80130d:	7f a4                	jg     8012b3 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  80130f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8b 55 0c             	mov    0xc(%ebp),%edx
  801325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80132b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80132e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801331:	cd 30                	int    $0x30
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801336:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    

00801341 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80134d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	52                   	push   %edx
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	50                   	push   %eax
  80135d:	6a 00                	push   $0x0
  80135f:	e8 b2 ff ff ff       	call   801316 <syscall>
  801364:	83 c4 18             	add    $0x18,%esp
}
  801367:	90                   	nop
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_cgetc>:

int
sys_cgetc(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 01                	push   $0x1
  801379:	e8 98 ff ff ff       	call   801316 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801386:	8b 55 0c             	mov    0xc(%ebp),%edx
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	52                   	push   %edx
  801393:	50                   	push   %eax
  801394:	6a 05                	push   $0x5
  801396:	e8 7b ff ff ff       	call   801316 <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8013a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	51                   	push   %ecx
  8013b7:	52                   	push   %edx
  8013b8:	50                   	push   %eax
  8013b9:	6a 06                	push   $0x6
  8013bb:	e8 56 ff ff ff       	call   801316 <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	52                   	push   %edx
  8013da:	50                   	push   %eax
  8013db:	6a 07                	push   $0x7
  8013dd:	e8 34 ff ff ff       	call   801316 <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	ff 75 08             	pushl  0x8(%ebp)
  8013f6:	6a 08                	push   $0x8
  8013f8:	e8 19 ff ff ff       	call   801316 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 09                	push   $0x9
  801411:	e8 00 ff ff ff       	call   801316 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 0a                	push   $0xa
  80142a:	e8 e7 fe ff ff       	call   801316 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 0b                	push   $0xb
  801443:	e8 ce fe ff ff       	call   801316 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 0c                	push   $0xc
  80145c:	e8 b5 fe ff ff       	call   801316 <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	ff 75 08             	pushl  0x8(%ebp)
  801474:	6a 0d                	push   $0xd
  801476:	e8 9b fe ff ff       	call   801316 <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 0e                	push   $0xe
  80148f:	e8 82 fe ff ff       	call   801316 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	90                   	nop
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 11                	push   $0x11
  8014a9:	e8 68 fe ff ff       	call   801316 <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 12                	push   $0x12
  8014c3:	e8 4e fe ff ff       	call   801316 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	90                   	nop
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <sys_cputc>:


void
sys_cputc(const char c)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	50                   	push   %eax
  8014e7:	6a 13                	push   $0x13
  8014e9:	e8 28 fe ff ff       	call   801316 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	90                   	nop
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 14                	push   $0x14
  801503:	e8 0e fe ff ff       	call   801316 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	90                   	nop
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	ff 75 0c             	pushl  0xc(%ebp)
  80151d:	50                   	push   %eax
  80151e:	6a 15                	push   $0x15
  801520:	e8 f1 fd ff ff       	call   801316 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80152d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 18                	push   $0x18
  80153d:	e8 d4 fd ff ff       	call   801316 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80154a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	52                   	push   %edx
  801557:	50                   	push   %eax
  801558:	6a 16                	push   $0x16
  80155a:	e8 b7 fd ff ff       	call   801316 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	90                   	nop
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	52                   	push   %edx
  801575:	50                   	push   %eax
  801576:	6a 17                	push   $0x17
  801578:	e8 99 fd ff ff       	call   801316 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	90                   	nop
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	8b 45 10             	mov    0x10(%ebp),%eax
  80158c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80158f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801592:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	6a 00                	push   $0x0
  80159b:	51                   	push   %ecx
  80159c:	52                   	push   %edx
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	50                   	push   %eax
  8015a1:	6a 19                	push   $0x19
  8015a3:	e8 6e fd ff ff       	call   801316 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	6a 1a                	push   $0x1a
  8015c0:	e8 51 fd ff ff       	call   801316 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	51                   	push   %ecx
  8015db:	52                   	push   %edx
  8015dc:	50                   	push   %eax
  8015dd:	6a 1b                	push   $0x1b
  8015df:	e8 32 fd ff ff       	call   801316 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	52                   	push   %edx
  8015f9:	50                   	push   %eax
  8015fa:	6a 1c                	push   $0x1c
  8015fc:	e8 15 fd ff ff       	call   801316 <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 1d                	push   $0x1d
  801615:	e8 fc fc ff ff       	call   801316 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	6a 00                	push   $0x0
  801627:	ff 75 14             	pushl  0x14(%ebp)
  80162a:	ff 75 10             	pushl  0x10(%ebp)
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	50                   	push   %eax
  801631:	6a 1e                	push   $0x1e
  801633:	e8 de fc ff ff       	call   801316 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	50                   	push   %eax
  80164c:	6a 1f                	push   $0x1f
  80164e:	e8 c3 fc ff ff       	call   801316 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	90                   	nop
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	50                   	push   %eax
  801668:	6a 20                	push   $0x20
  80166a:	e8 a7 fc ff ff       	call   801316 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 02                	push   $0x2
  801683:	e8 8e fc ff ff       	call   801316 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 03                	push   $0x3
  80169c:	e8 75 fc ff ff       	call   801316 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 04                	push   $0x4
  8016b5:	e8 5c fc ff ff       	call   801316 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_exit_env>:


void sys_exit_env(void)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 21                	push   $0x21
  8016ce:	e8 43 fc ff ff       	call   801316 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	90                   	nop
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016e2:	8d 50 04             	lea    0x4(%eax),%edx
  8016e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	52                   	push   %edx
  8016ef:	50                   	push   %eax
  8016f0:	6a 22                	push   $0x22
  8016f2:	e8 1f fc ff ff       	call   801316 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
	return result;
  8016fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801703:	89 01                	mov    %eax,(%ecx)
  801705:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	c9                   	leave  
  80170c:	c2 04 00             	ret    $0x4

0080170f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	ff 75 10             	pushl  0x10(%ebp)
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	6a 10                	push   $0x10
  801721:	e8 f0 fb ff ff       	call   801316 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
	return ;
  801729:	90                   	nop
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_rcr2>:
uint32 sys_rcr2()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 23                	push   $0x23
  80173b:	e8 d6 fb ff ff       	call   801316 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801751:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	50                   	push   %eax
  80175e:	6a 24                	push   $0x24
  801760:	e8 b1 fb ff ff       	call   801316 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
	return ;
  801768:	90                   	nop
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <rsttst>:
void rsttst()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 26                	push   $0x26
  80177a:	e8 97 fb ff ff       	call   801316 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
	return ;
  801782:	90                   	nop
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	8b 45 14             	mov    0x14(%ebp),%eax
  80178e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801791:	8b 55 18             	mov    0x18(%ebp),%edx
  801794:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801798:	52                   	push   %edx
  801799:	50                   	push   %eax
  80179a:	ff 75 10             	pushl  0x10(%ebp)
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	6a 25                	push   $0x25
  8017a5:	e8 6c fb ff ff       	call   801316 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <chktst>:
void chktst(uint32 n)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	6a 27                	push   $0x27
  8017c0:	e8 51 fb ff ff       	call   801316 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c8:	90                   	nop
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <inctst>:

void inctst()
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 28                	push   $0x28
  8017da:	e8 37 fb ff ff       	call   801316 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e2:	90                   	nop
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <gettst>:
uint32 gettst()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 29                	push   $0x29
  8017f4:	e8 1d fb ff ff       	call   801316 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 2a                	push   $0x2a
  801810:	e8 01 fb ff ff       	call   801316 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
  801818:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80181b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80181f:	75 07                	jne    801828 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801821:	b8 01 00 00 00       	mov    $0x1,%eax
  801826:	eb 05                	jmp    80182d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 2a                	push   $0x2a
  801841:	e8 d0 fa ff ff       	call   801316 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
  801849:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80184c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801850:	75 07                	jne    801859 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801852:	b8 01 00 00 00       	mov    $0x1,%eax
  801857:	eb 05                	jmp    80185e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 2a                	push   $0x2a
  801872:	e8 9f fa ff ff       	call   801316 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
  80187a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80187d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801881:	75 07                	jne    80188a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801883:	b8 01 00 00 00       	mov    $0x1,%eax
  801888:	eb 05                	jmp    80188f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 2a                	push   $0x2a
  8018a3:	e8 6e fa ff ff       	call   801316 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
  8018ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018ae:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018b2:	75 07                	jne    8018bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b9:	eb 05                	jmp    8018c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 2b                	push   $0x2b
  8018d2:	e8 3f fa ff ff       	call   801316 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018da:	90                   	nop
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	53                   	push   %ebx
  8018f0:	51                   	push   %ecx
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 2c                	push   $0x2c
  8018f5:	e8 1c fa ff ff       	call   801316 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 2d                	push   $0x2d
  801915:	e8 fc f9 ff ff       	call   801316 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801922:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	51                   	push   %ecx
  80192e:	ff 75 10             	pushl  0x10(%ebp)
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 2e                	push   $0x2e
  801935:	e8 dc f9 ff ff       	call   801316 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 0f                	push   $0xf
  801951:	e8 c0 f9 ff ff       	call   801316 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	50                   	push   %eax
  80196b:	6a 2f                	push   $0x2f
  80196d:	e8 a4 f9 ff ff       	call   801316 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp

}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	6a 30                	push   $0x30
  801988:	e8 89 f9 ff ff       	call   801316 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
	return;
  801990:	90                   	nop
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 31                	push   $0x31
  8019a4:	e8 6d f9 ff ff       	call   801316 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 32                	push   $0x32
  8019be:	e8 53 f9 ff ff       	call   801316 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	50                   	push   %eax
  8019d7:	6a 33                	push   $0x33
  8019d9:	e8 38 f9 ff ff       	call   801316 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <__udivdi3>:
  8019e4:	55                   	push   %ebp
  8019e5:	57                   	push   %edi
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 1c             	sub    $0x1c,%esp
  8019eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019fb:	89 ca                	mov    %ecx,%edx
  8019fd:	89 f8                	mov    %edi,%eax
  8019ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a03:	85 f6                	test   %esi,%esi
  801a05:	75 2d                	jne    801a34 <__udivdi3+0x50>
  801a07:	39 cf                	cmp    %ecx,%edi
  801a09:	77 65                	ja     801a70 <__udivdi3+0x8c>
  801a0b:	89 fd                	mov    %edi,%ebp
  801a0d:	85 ff                	test   %edi,%edi
  801a0f:	75 0b                	jne    801a1c <__udivdi3+0x38>
  801a11:	b8 01 00 00 00       	mov    $0x1,%eax
  801a16:	31 d2                	xor    %edx,%edx
  801a18:	f7 f7                	div    %edi
  801a1a:	89 c5                	mov    %eax,%ebp
  801a1c:	31 d2                	xor    %edx,%edx
  801a1e:	89 c8                	mov    %ecx,%eax
  801a20:	f7 f5                	div    %ebp
  801a22:	89 c1                	mov    %eax,%ecx
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	f7 f5                	div    %ebp
  801a28:	89 cf                	mov    %ecx,%edi
  801a2a:	89 fa                	mov    %edi,%edx
  801a2c:	83 c4 1c             	add    $0x1c,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
  801a34:	39 ce                	cmp    %ecx,%esi
  801a36:	77 28                	ja     801a60 <__udivdi3+0x7c>
  801a38:	0f bd fe             	bsr    %esi,%edi
  801a3b:	83 f7 1f             	xor    $0x1f,%edi
  801a3e:	75 40                	jne    801a80 <__udivdi3+0x9c>
  801a40:	39 ce                	cmp    %ecx,%esi
  801a42:	72 0a                	jb     801a4e <__udivdi3+0x6a>
  801a44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a48:	0f 87 9e 00 00 00    	ja     801aec <__udivdi3+0x108>
  801a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a53:	89 fa                	mov    %edi,%edx
  801a55:	83 c4 1c             	add    $0x1c,%esp
  801a58:	5b                   	pop    %ebx
  801a59:	5e                   	pop    %esi
  801a5a:	5f                   	pop    %edi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    
  801a5d:	8d 76 00             	lea    0x0(%esi),%esi
  801a60:	31 ff                	xor    %edi,%edi
  801a62:	31 c0                	xor    %eax,%eax
  801a64:	89 fa                	mov    %edi,%edx
  801a66:	83 c4 1c             	add    $0x1c,%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5f                   	pop    %edi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	89 d8                	mov    %ebx,%eax
  801a72:	f7 f7                	div    %edi
  801a74:	31 ff                	xor    %edi,%edi
  801a76:	89 fa                	mov    %edi,%edx
  801a78:	83 c4 1c             	add    $0x1c,%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    
  801a80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a85:	89 eb                	mov    %ebp,%ebx
  801a87:	29 fb                	sub    %edi,%ebx
  801a89:	89 f9                	mov    %edi,%ecx
  801a8b:	d3 e6                	shl    %cl,%esi
  801a8d:	89 c5                	mov    %eax,%ebp
  801a8f:	88 d9                	mov    %bl,%cl
  801a91:	d3 ed                	shr    %cl,%ebp
  801a93:	89 e9                	mov    %ebp,%ecx
  801a95:	09 f1                	or     %esi,%ecx
  801a97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a9b:	89 f9                	mov    %edi,%ecx
  801a9d:	d3 e0                	shl    %cl,%eax
  801a9f:	89 c5                	mov    %eax,%ebp
  801aa1:	89 d6                	mov    %edx,%esi
  801aa3:	88 d9                	mov    %bl,%cl
  801aa5:	d3 ee                	shr    %cl,%esi
  801aa7:	89 f9                	mov    %edi,%ecx
  801aa9:	d3 e2                	shl    %cl,%edx
  801aab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 e8                	shr    %cl,%eax
  801ab3:	09 c2                	or     %eax,%edx
  801ab5:	89 d0                	mov    %edx,%eax
  801ab7:	89 f2                	mov    %esi,%edx
  801ab9:	f7 74 24 0c          	divl   0xc(%esp)
  801abd:	89 d6                	mov    %edx,%esi
  801abf:	89 c3                	mov    %eax,%ebx
  801ac1:	f7 e5                	mul    %ebp
  801ac3:	39 d6                	cmp    %edx,%esi
  801ac5:	72 19                	jb     801ae0 <__udivdi3+0xfc>
  801ac7:	74 0b                	je     801ad4 <__udivdi3+0xf0>
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	31 ff                	xor    %edi,%edi
  801acd:	e9 58 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad8:	89 f9                	mov    %edi,%ecx
  801ada:	d3 e2                	shl    %cl,%edx
  801adc:	39 c2                	cmp    %eax,%edx
  801ade:	73 e9                	jae    801ac9 <__udivdi3+0xe5>
  801ae0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ae3:	31 ff                	xor    %edi,%edi
  801ae5:	e9 40 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	31 c0                	xor    %eax,%eax
  801aee:	e9 37 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801af3:	90                   	nop

00801af4 <__umoddi3>:
  801af4:	55                   	push   %ebp
  801af5:	57                   	push   %edi
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 1c             	sub    $0x1c,%esp
  801afb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b13:	89 f3                	mov    %esi,%ebx
  801b15:	89 fa                	mov    %edi,%edx
  801b17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1b:	89 34 24             	mov    %esi,(%esp)
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	75 1a                	jne    801b3c <__umoddi3+0x48>
  801b22:	39 f7                	cmp    %esi,%edi
  801b24:	0f 86 a2 00 00 00    	jbe    801bcc <__umoddi3+0xd8>
  801b2a:	89 c8                	mov    %ecx,%eax
  801b2c:	89 f2                	mov    %esi,%edx
  801b2e:	f7 f7                	div    %edi
  801b30:	89 d0                	mov    %edx,%eax
  801b32:	31 d2                	xor    %edx,%edx
  801b34:	83 c4 1c             	add    $0x1c,%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5f                   	pop    %edi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
  801b3c:	39 f0                	cmp    %esi,%eax
  801b3e:	0f 87 ac 00 00 00    	ja     801bf0 <__umoddi3+0xfc>
  801b44:	0f bd e8             	bsr    %eax,%ebp
  801b47:	83 f5 1f             	xor    $0x1f,%ebp
  801b4a:	0f 84 ac 00 00 00    	je     801bfc <__umoddi3+0x108>
  801b50:	bf 20 00 00 00       	mov    $0x20,%edi
  801b55:	29 ef                	sub    %ebp,%edi
  801b57:	89 fe                	mov    %edi,%esi
  801b59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b5d:	89 e9                	mov    %ebp,%ecx
  801b5f:	d3 e0                	shl    %cl,%eax
  801b61:	89 d7                	mov    %edx,%edi
  801b63:	89 f1                	mov    %esi,%ecx
  801b65:	d3 ef                	shr    %cl,%edi
  801b67:	09 c7                	or     %eax,%edi
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 e2                	shl    %cl,%edx
  801b6d:	89 14 24             	mov    %edx,(%esp)
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	d3 e0                	shl    %cl,%eax
  801b74:	89 c2                	mov    %eax,%edx
  801b76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7a:	d3 e0                	shl    %cl,%eax
  801b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b84:	89 f1                	mov    %esi,%ecx
  801b86:	d3 e8                	shr    %cl,%eax
  801b88:	09 d0                	or     %edx,%eax
  801b8a:	d3 eb                	shr    %cl,%ebx
  801b8c:	89 da                	mov    %ebx,%edx
  801b8e:	f7 f7                	div    %edi
  801b90:	89 d3                	mov    %edx,%ebx
  801b92:	f7 24 24             	mull   (%esp)
  801b95:	89 c6                	mov    %eax,%esi
  801b97:	89 d1                	mov    %edx,%ecx
  801b99:	39 d3                	cmp    %edx,%ebx
  801b9b:	0f 82 87 00 00 00    	jb     801c28 <__umoddi3+0x134>
  801ba1:	0f 84 91 00 00 00    	je     801c38 <__umoddi3+0x144>
  801ba7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bab:	29 f2                	sub    %esi,%edx
  801bad:	19 cb                	sbb    %ecx,%ebx
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bb5:	d3 e0                	shl    %cl,%eax
  801bb7:	89 e9                	mov    %ebp,%ecx
  801bb9:	d3 ea                	shr    %cl,%edx
  801bbb:	09 d0                	or     %edx,%eax
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 eb                	shr    %cl,%ebx
  801bc1:	89 da                	mov    %ebx,%edx
  801bc3:	83 c4 1c             	add    $0x1c,%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5f                   	pop    %edi
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    
  801bcb:	90                   	nop
  801bcc:	89 fd                	mov    %edi,%ebp
  801bce:	85 ff                	test   %edi,%edi
  801bd0:	75 0b                	jne    801bdd <__umoddi3+0xe9>
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	31 d2                	xor    %edx,%edx
  801bd9:	f7 f7                	div    %edi
  801bdb:	89 c5                	mov    %eax,%ebp
  801bdd:	89 f0                	mov    %esi,%eax
  801bdf:	31 d2                	xor    %edx,%edx
  801be1:	f7 f5                	div    %ebp
  801be3:	89 c8                	mov    %ecx,%eax
  801be5:	f7 f5                	div    %ebp
  801be7:	89 d0                	mov    %edx,%eax
  801be9:	e9 44 ff ff ff       	jmp    801b32 <__umoddi3+0x3e>
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	89 c8                	mov    %ecx,%eax
  801bf2:	89 f2                	mov    %esi,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	3b 04 24             	cmp    (%esp),%eax
  801bff:	72 06                	jb     801c07 <__umoddi3+0x113>
  801c01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c05:	77 0f                	ja     801c16 <__umoddi3+0x122>
  801c07:	89 f2                	mov    %esi,%edx
  801c09:	29 f9                	sub    %edi,%ecx
  801c0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c0f:	89 14 24             	mov    %edx,(%esp)
  801c12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c1a:	8b 14 24             	mov    (%esp),%edx
  801c1d:	83 c4 1c             	add    $0x1c,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
  801c25:	8d 76 00             	lea    0x0(%esi),%esi
  801c28:	2b 04 24             	sub    (%esp),%eax
  801c2b:	19 fa                	sbb    %edi,%edx
  801c2d:	89 d1                	mov    %edx,%ecx
  801c2f:	89 c6                	mov    %eax,%esi
  801c31:	e9 71 ff ff ff       	jmp    801ba7 <__umoddi3+0xb3>
  801c36:	66 90                	xchg   %ax,%ax
  801c38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c3c:	72 ea                	jb     801c28 <__umoddi3+0x134>
  801c3e:	89 d9                	mov    %ebx,%ecx
  801c40:	e9 62 ff ff ff       	jmp    801ba7 <__umoddi3+0xb3>
