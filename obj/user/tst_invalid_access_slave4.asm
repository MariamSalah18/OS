
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 b0 16 00 00       	call   80172e <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 a0 1b 80 00       	push   $0x801ba0
  800086:	6a 18                	push   $0x18
  800088:	68 3c 1c 80 00       	push   $0x801c3c
  80008d:	e8 2e 01 00 00       	call   8001c0 <_panic>

00800092 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800098:	e8 53 15 00 00       	call   8015f0 <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	01 c0                	add    %eax,%eax
  8000a7:	01 d0                	add    %edx,%eax
  8000a9:	c1 e0 06             	shl    $0x6,%eax
  8000ac:	29 d0                	sub    %edx,%eax
  8000ae:	c1 e0 03             	shl    $0x3,%eax
  8000b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c0:	8a 40 68             	mov    0x68(%eax),%al
  8000c3:	84 c0                	test   %al,%al
  8000c5:	74 0d                	je     8000d4 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8000c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cc:	83 c0 68             	add    $0x68,%eax
  8000cf:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d8:	7e 0a                	jle    8000e4 <libmain+0x52>
		binaryname = argv[0];
  8000da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000dd:	8b 00                	mov    (%eax),%eax
  8000df:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000e4:	83 ec 08             	sub    $0x8,%esp
  8000e7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ea:	ff 75 08             	pushl  0x8(%ebp)
  8000ed:	e8 46 ff ff ff       	call   800038 <_main>
  8000f2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000f5:	e8 03 13 00 00       	call   8013fd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 78 1c 80 00       	push   $0x801c78
  800102:	e8 76 03 00 00       	call   80047d <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80010a:	a1 20 30 80 00       	mov    0x803020,%eax
  80010f:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800115:	a1 20 30 80 00       	mov    0x803020,%eax
  80011a:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	68 a0 1c 80 00       	push   $0x801ca0
  80012a:	e8 4e 03 00 00       	call   80047d <cprintf>
  80012f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800132:	a1 20 30 80 00       	mov    0x803020,%eax
  800137:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80013d:	a1 20 30 80 00       	mov    0x803020,%eax
  800142:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800148:	a1 20 30 80 00       	mov    0x803020,%eax
  80014d:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800153:	51                   	push   %ecx
  800154:	52                   	push   %edx
  800155:	50                   	push   %eax
  800156:	68 c8 1c 80 00       	push   $0x801cc8
  80015b:	e8 1d 03 00 00       	call   80047d <cprintf>
  800160:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800163:	a1 20 30 80 00       	mov    0x803020,%eax
  800168:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	50                   	push   %eax
  800172:	68 20 1d 80 00       	push   $0x801d20
  800177:	e8 01 03 00 00       	call   80047d <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 78 1c 80 00       	push   $0x801c78
  800187:	e8 f1 02 00 00       	call   80047d <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80018f:	e8 83 12 00 00       	call   801417 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800194:	e8 19 00 00 00       	call   8001b2 <exit>
}
  800199:	90                   	nop
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	6a 00                	push   $0x0
  8001a7:	e8 10 14 00 00       	call   8015bc <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
}
  8001af:	90                   	nop
  8001b0:	c9                   	leave  
  8001b1:	c3                   	ret    

008001b2 <exit>:

void
exit(void)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001b8:	e8 65 14 00 00       	call   801622 <sys_exit_env>
}
  8001bd:	90                   	nop
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    

008001c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001c6:	8d 45 10             	lea    0x10(%ebp),%eax
  8001c9:	83 c0 04             	add    $0x4,%eax
  8001cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001cf:	a1 18 31 80 00       	mov    0x803118,%eax
  8001d4:	85 c0                	test   %eax,%eax
  8001d6:	74 16                	je     8001ee <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001d8:	a1 18 31 80 00       	mov    0x803118,%eax
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	50                   	push   %eax
  8001e1:	68 34 1d 80 00       	push   $0x801d34
  8001e6:	e8 92 02 00 00       	call   80047d <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001ee:	a1 00 30 80 00       	mov    0x803000,%eax
  8001f3:	ff 75 0c             	pushl  0xc(%ebp)
  8001f6:	ff 75 08             	pushl  0x8(%ebp)
  8001f9:	50                   	push   %eax
  8001fa:	68 39 1d 80 00       	push   $0x801d39
  8001ff:	e8 79 02 00 00       	call   80047d <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800207:	8b 45 10             	mov    0x10(%ebp),%eax
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	ff 75 f4             	pushl  -0xc(%ebp)
  800210:	50                   	push   %eax
  800211:	e8 fc 01 00 00       	call   800412 <vcprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	6a 00                	push   $0x0
  80021e:	68 55 1d 80 00       	push   $0x801d55
  800223:	e8 ea 01 00 00       	call   800412 <vcprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80022b:	e8 82 ff ff ff       	call   8001b2 <exit>

	// should not return here
	while (1) ;
  800230:	eb fe                	jmp    800230 <_panic+0x70>

00800232 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800243:	8b 45 0c             	mov    0xc(%ebp),%eax
  800246:	39 c2                	cmp    %eax,%edx
  800248:	74 14                	je     80025e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 58 1d 80 00       	push   $0x801d58
  800252:	6a 26                	push   $0x26
  800254:	68 a4 1d 80 00       	push   $0x801da4
  800259:	e8 62 ff ff ff       	call   8001c0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800265:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026c:	e9 c5 00 00 00       	jmp    800336 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800274:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80027b:	8b 45 08             	mov    0x8(%ebp),%eax
  80027e:	01 d0                	add    %edx,%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	85 c0                	test   %eax,%eax
  800284:	75 08                	jne    80028e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800286:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800289:	e9 a5 00 00 00       	jmp    800333 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80028e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800295:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80029c:	eb 69                	jmp    800307 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80029e:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a3:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ac:	89 d0                	mov    %edx,%eax
  8002ae:	01 c0                	add    %eax,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 03             	shl    $0x3,%eax
  8002b5:	01 c8                	add    %ecx,%eax
  8002b7:	8a 40 04             	mov    0x4(%eax),%al
  8002ba:	84 c0                	test   %al,%al
  8002bc:	75 46                	jne    800304 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002be:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c3:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002cc:	89 d0                	mov    %edx,%eax
  8002ce:	01 c0                	add    %eax,%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 03             	shl    $0x3,%eax
  8002d5:	01 c8                	add    %ecx,%eax
  8002d7:	8b 00                	mov    (%eax),%eax
  8002d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	01 c8                	add    %ecx,%eax
  8002f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002f7:	39 c2                	cmp    %eax,%edx
  8002f9:	75 09                	jne    800304 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800302:	eb 15                	jmp    800319 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800304:	ff 45 e8             	incl   -0x18(%ebp)
  800307:	a1 20 30 80 00       	mov    0x803020,%eax
  80030c:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800315:	39 c2                	cmp    %eax,%edx
  800317:	77 85                	ja     80029e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800319:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80031d:	75 14                	jne    800333 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80031f:	83 ec 04             	sub    $0x4,%esp
  800322:	68 b0 1d 80 00       	push   $0x801db0
  800327:	6a 3a                	push   $0x3a
  800329:	68 a4 1d 80 00       	push   $0x801da4
  80032e:	e8 8d fe ff ff       	call   8001c0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800333:	ff 45 f0             	incl   -0x10(%ebp)
  800336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800339:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80033c:	0f 8c 2f ff ff ff    	jl     800271 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800342:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800350:	eb 26                	jmp    800378 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80035d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	3c 01                	cmp    $0x1,%al
  800370:	75 03                	jne    800375 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800372:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800375:	ff 45 e0             	incl   -0x20(%ebp)
  800378:	a1 20 30 80 00       	mov    0x803020,%eax
  80037d:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800386:	39 c2                	cmp    %eax,%edx
  800388:	77 c8                	ja     800352 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800390:	74 14                	je     8003a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800392:	83 ec 04             	sub    $0x4,%esp
  800395:	68 04 1e 80 00       	push   $0x801e04
  80039a:	6a 44                	push   $0x44
  80039c:	68 a4 1d 80 00       	push   $0x801da4
  8003a1:	e8 1a fe ff ff       	call   8001c0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003a6:	90                   	nop
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	89 0a                	mov    %ecx,(%edx)
  8003bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bf:	88 d1                	mov    %dl,%cl
  8003c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d2:	75 2c                	jne    800400 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003d4:	a0 24 30 80 00       	mov    0x803024,%al
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003df:	8b 12                	mov    (%edx),%edx
  8003e1:	89 d1                	mov    %edx,%ecx
  8003e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e6:	83 c2 08             	add    $0x8,%edx
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	50                   	push   %eax
  8003ed:	51                   	push   %ecx
  8003ee:	52                   	push   %edx
  8003ef:	e8 b0 0e 00 00       	call   8012a4 <sys_cputs>
  8003f4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	8b 40 04             	mov    0x4(%eax),%eax
  800406:	8d 50 01             	lea    0x1(%eax),%edx
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80041b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800422:	00 00 00 
	b.cnt = 0;
  800425:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80042c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043b:	50                   	push   %eax
  80043c:	68 a9 03 80 00       	push   $0x8003a9
  800441:	e8 11 02 00 00       	call   800657 <vprintfmt>
  800446:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800449:	a0 24 30 80 00       	mov    0x803024,%al
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	50                   	push   %eax
  80045b:	52                   	push   %edx
  80045c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800462:	83 c0 08             	add    $0x8,%eax
  800465:	50                   	push   %eax
  800466:	e8 39 0e 00 00       	call   8012a4 <sys_cputs>
  80046b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80046e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800475:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <cprintf>:

int cprintf(const char *fmt, ...) {
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800483:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 f4             	pushl  -0xc(%ebp)
  800499:	50                   	push   %eax
  80049a:	e8 73 ff ff ff       	call   800412 <vcprintf>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004b0:	e8 48 0f 00 00       	call   8013fd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c4:	50                   	push   %eax
  8004c5:	e8 48 ff ff ff       	call   800412 <vcprintf>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004d0:	e8 42 0f 00 00       	call   801417 <sys_enable_interrupt>
	return cnt;
  8004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	53                   	push   %ebx
  8004de:	83 ec 14             	sub    $0x14,%esp
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004f8:	77 55                	ja     80054f <printnum+0x75>
  8004fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004fd:	72 05                	jb     800504 <printnum+0x2a>
  8004ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800502:	77 4b                	ja     80054f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800504:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800507:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80050a:	8b 45 18             	mov    0x18(%ebp),%eax
  80050d:	ba 00 00 00 00       	mov    $0x0,%edx
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	ff 75 f4             	pushl  -0xc(%ebp)
  800517:	ff 75 f0             	pushl  -0x10(%ebp)
  80051a:	e8 0d 14 00 00       	call   80192c <__udivdi3>
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	ff 75 20             	pushl  0x20(%ebp)
  800528:	53                   	push   %ebx
  800529:	ff 75 18             	pushl  0x18(%ebp)
  80052c:	52                   	push   %edx
  80052d:	50                   	push   %eax
  80052e:	ff 75 0c             	pushl  0xc(%ebp)
  800531:	ff 75 08             	pushl  0x8(%ebp)
  800534:	e8 a1 ff ff ff       	call   8004da <printnum>
  800539:	83 c4 20             	add    $0x20,%esp
  80053c:	eb 1a                	jmp    800558 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	ff 75 0c             	pushl  0xc(%ebp)
  800544:	ff 75 20             	pushl  0x20(%ebp)
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	ff d0                	call   *%eax
  80054c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80054f:	ff 4d 1c             	decl   0x1c(%ebp)
  800552:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800556:	7f e6                	jg     80053e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800558:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80055b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800566:	53                   	push   %ebx
  800567:	51                   	push   %ecx
  800568:	52                   	push   %edx
  800569:	50                   	push   %eax
  80056a:	e8 cd 14 00 00       	call   801a3c <__umoddi3>
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	05 74 20 80 00       	add    $0x802074,%eax
  800577:	8a 00                	mov    (%eax),%al
  800579:	0f be c0             	movsbl %al,%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	ff d0                	call   *%eax
  800588:	83 c4 10             	add    $0x10,%esp
}
  80058b:	90                   	nop
  80058c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058f:	c9                   	leave  
  800590:	c3                   	ret    

00800591 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800594:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800598:	7e 1c                	jle    8005b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	8d 50 08             	lea    0x8(%eax),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	89 10                	mov    %edx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	83 e8 08             	sub    $0x8,%eax
  8005af:	8b 50 04             	mov    0x4(%eax),%edx
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	eb 40                	jmp    8005f6 <getuint+0x65>
	else if (lflag)
  8005b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ba:	74 1e                	je     8005da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	8d 50 04             	lea    0x4(%eax),%edx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	89 10                	mov    %edx,(%eax)
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	eb 1c                	jmp    8005f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 50 04             	lea    0x4(%eax),%edx
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	89 10                	mov    %edx,(%eax)
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005f6:	5d                   	pop    %ebp
  8005f7:	c3                   	ret    

008005f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ff:	7e 1c                	jle    80061d <getint+0x25>
		return va_arg(*ap, long long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 08             	lea    0x8(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 08             	sub    $0x8,%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	eb 38                	jmp    800655 <getint+0x5d>
	else if (lflag)
  80061d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800621:	74 1a                	je     80063d <getint+0x45>
		return va_arg(*ap, long);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 04             	sub    $0x4,%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	99                   	cltd   
  80063b:	eb 18                	jmp    800655 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	83 e8 04             	sub    $0x4,%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	99                   	cltd   
}
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	56                   	push   %esi
  80065b:	53                   	push   %ebx
  80065c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065f:	eb 17                	jmp    800678 <vprintfmt+0x21>
			if (ch == '\0')
  800661:	85 db                	test   %ebx,%ebx
  800663:	0f 84 af 03 00 00    	je     800a18 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	53                   	push   %ebx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800678:	8b 45 10             	mov    0x10(%ebp),%eax
  80067b:	8d 50 01             	lea    0x1(%eax),%edx
  80067e:	89 55 10             	mov    %edx,0x10(%ebp)
  800681:	8a 00                	mov    (%eax),%al
  800683:	0f b6 d8             	movzbl %al,%ebx
  800686:	83 fb 25             	cmp    $0x25,%ebx
  800689:	75 d6                	jne    800661 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80068b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80068f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800696:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80069d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ae:	8d 50 01             	lea    0x1(%eax),%edx
  8006b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8006b4:	8a 00                	mov    (%eax),%al
  8006b6:	0f b6 d8             	movzbl %al,%ebx
  8006b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006bc:	83 f8 55             	cmp    $0x55,%eax
  8006bf:	0f 87 2b 03 00 00    	ja     8009f0 <vprintfmt+0x399>
  8006c5:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  8006cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006d2:	eb d7                	jmp    8006ab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006d8:	eb d1                	jmp    8006ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	c1 e0 02             	shl    $0x2,%eax
  8006e9:	01 d0                	add    %edx,%eax
  8006eb:	01 c0                	add    %eax,%eax
  8006ed:	01 d8                	add    %ebx,%eax
  8006ef:	83 e8 30             	sub    $0x30,%eax
  8006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f8:	8a 00                	mov    (%eax),%al
  8006fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800700:	7e 3e                	jle    800740 <vprintfmt+0xe9>
  800702:	83 fb 39             	cmp    $0x39,%ebx
  800705:	7f 39                	jg     800740 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800707:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070a:	eb d5                	jmp    8006e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	83 c0 04             	add    $0x4,%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	83 e8 04             	sub    $0x4,%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800720:	eb 1f                	jmp    800741 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	79 83                	jns    8006ab <vprintfmt+0x54>
				width = 0;
  800728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80072f:	e9 77 ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800734:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80073b:	e9 6b ff ff ff       	jmp    8006ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800740:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800745:	0f 89 60 ff ff ff    	jns    8006ab <vprintfmt+0x54>
				width = precision, precision = -1;
  80074b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800751:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800758:	e9 4e ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80075d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800760:	e9 46 ff ff ff       	jmp    8006ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	83 c0 04             	add    $0x4,%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 e8 04             	sub    $0x4,%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
			break;
  800785:	e9 89 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	83 c0 04             	add    $0x4,%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	83 e8 04             	sub    $0x4,%eax
  800799:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80079b:	85 db                	test   %ebx,%ebx
  80079d:	79 02                	jns    8007a1 <vprintfmt+0x14a>
				err = -err;
  80079f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007a1:	83 fb 64             	cmp    $0x64,%ebx
  8007a4:	7f 0b                	jg     8007b1 <vprintfmt+0x15a>
  8007a6:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  8007ad:	85 f6                	test   %esi,%esi
  8007af:	75 19                	jne    8007ca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007b1:	53                   	push   %ebx
  8007b2:	68 85 20 80 00       	push   $0x802085
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	ff 75 08             	pushl  0x8(%ebp)
  8007bd:	e8 5e 02 00 00       	call   800a20 <printfmt>
  8007c2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007c5:	e9 49 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ca:	56                   	push   %esi
  8007cb:	68 8e 20 80 00       	push   $0x80208e
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	ff 75 08             	pushl  0x8(%ebp)
  8007d6:	e8 45 02 00 00       	call   800a20 <printfmt>
  8007db:	83 c4 10             	add    $0x10,%esp
			break;
  8007de:	e9 30 02 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	83 c0 04             	add    $0x4,%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 e8 04             	sub    $0x4,%eax
  8007f2:	8b 30                	mov    (%eax),%esi
  8007f4:	85 f6                	test   %esi,%esi
  8007f6:	75 05                	jne    8007fd <vprintfmt+0x1a6>
				p = "(null)";
  8007f8:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  8007fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800801:	7e 6d                	jle    800870 <vprintfmt+0x219>
  800803:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800807:	74 67                	je     800870 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	50                   	push   %eax
  800810:	56                   	push   %esi
  800811:	e8 0c 03 00 00       	call   800b22 <strnlen>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80081c:	eb 16                	jmp    800834 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80081e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	50                   	push   %eax
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800831:	ff 4d e4             	decl   -0x1c(%ebp)
  800834:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800838:	7f e4                	jg     80081e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083a:	eb 34                	jmp    800870 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80083c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800840:	74 1c                	je     80085e <vprintfmt+0x207>
  800842:	83 fb 1f             	cmp    $0x1f,%ebx
  800845:	7e 05                	jle    80084c <vprintfmt+0x1f5>
  800847:	83 fb 7e             	cmp    $0x7e,%ebx
  80084a:	7e 12                	jle    80085e <vprintfmt+0x207>
					putch('?', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	6a 3f                	push   $0x3f
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	eb 0f                	jmp    80086d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	53                   	push   %ebx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80086d:	ff 4d e4             	decl   -0x1c(%ebp)
  800870:	89 f0                	mov    %esi,%eax
  800872:	8d 70 01             	lea    0x1(%eax),%esi
  800875:	8a 00                	mov    (%eax),%al
  800877:	0f be d8             	movsbl %al,%ebx
  80087a:	85 db                	test   %ebx,%ebx
  80087c:	74 24                	je     8008a2 <vprintfmt+0x24b>
  80087e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800882:	78 b8                	js     80083c <vprintfmt+0x1e5>
  800884:	ff 4d e0             	decl   -0x20(%ebp)
  800887:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088b:	79 af                	jns    80083c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80088d:	eb 13                	jmp    8008a2 <vprintfmt+0x24b>
				putch(' ', putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	6a 20                	push   $0x20
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	ff d0                	call   *%eax
  80089c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089f:	ff 4d e4             	decl   -0x1c(%ebp)
  8008a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a6:	7f e7                	jg     80088f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008a8:	e9 66 01 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	e8 3c fd ff ff       	call   8005f8 <getint>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	79 23                	jns    8008f2 <vprintfmt+0x29b>
				putch('-', putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	6a 2d                	push   $0x2d
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e5:	f7 d8                	neg    %eax
  8008e7:	83 d2 00             	adc    $0x0,%edx
  8008ea:	f7 da                	neg    %edx
  8008ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f9:	e9 bc 00 00 00       	jmp    8009ba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	ff 75 e8             	pushl  -0x18(%ebp)
  800904:	8d 45 14             	lea    0x14(%ebp),%eax
  800907:	50                   	push   %eax
  800908:	e8 84 fc ff ff       	call   800591 <getuint>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800913:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800916:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80091d:	e9 98 00 00 00       	jmp    8009ba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	6a 58                	push   $0x58
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	6a 58                	push   $0x58
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	6a 58                	push   $0x58
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	ff d0                	call   *%eax
  80094f:	83 c4 10             	add    $0x10,%esp
			break;
  800952:	e9 bc 00 00 00       	jmp    800a13 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	6a 30                	push   $0x30
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 78                	push   $0x78
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 c0 04             	add    $0x4,%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	83 e8 04             	sub    $0x4,%eax
  800986:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800988:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800992:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800999:	eb 1f                	jmp    8009ba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 e7 fb ff ff       	call   800591 <getuint>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c1:	83 ec 04             	sub    $0x4,%esp
  8009c4:	52                   	push   %edx
  8009c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009c8:	50                   	push   %eax
  8009c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	ff 75 08             	pushl  0x8(%ebp)
  8009d5:	e8 00 fb ff ff       	call   8004da <printnum>
  8009da:	83 c4 20             	add    $0x20,%esp
			break;
  8009dd:	eb 34                	jmp    800a13 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
			break;
  8009ee:	eb 23                	jmp    800a13 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 25                	push   $0x25
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a00:	ff 4d 10             	decl   0x10(%ebp)
  800a03:	eb 03                	jmp    800a08 <vprintfmt+0x3b1>
  800a05:	ff 4d 10             	decl   0x10(%ebp)
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	48                   	dec    %eax
  800a0c:	8a 00                	mov    (%eax),%al
  800a0e:	3c 25                	cmp    $0x25,%al
  800a10:	75 f3                	jne    800a05 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a12:	90                   	nop
		}
	}
  800a13:	e9 47 fc ff ff       	jmp    80065f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a18:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a26:	8d 45 10             	lea    0x10(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a32:	ff 75 f4             	pushl  -0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 16 fc ff ff       	call   800657 <vprintfmt>
  800a41:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a44:	90                   	nop
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 40 08             	mov    0x8(%eax),%eax
  800a50:	8d 50 01             	lea    0x1(%eax),%edx
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8b 10                	mov    (%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8b 40 04             	mov    0x4(%eax),%eax
  800a64:	39 c2                	cmp    %eax,%edx
  800a66:	73 12                	jae    800a7a <sprintputch+0x33>
		*b->buf++ = ch;
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a73:	89 0a                	mov    %ecx,(%edx)
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
  800a78:	88 10                	mov    %dl,(%eax)
}
  800a7a:	90                   	nop
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa2:	74 06                	je     800aaa <vsnprintf+0x2d>
  800aa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa8:	7f 07                	jg     800ab1 <vsnprintf+0x34>
		return -E_INVAL;
  800aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aaf:	eb 20                	jmp    800ad1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab1:	ff 75 14             	pushl  0x14(%ebp)
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	68 47 0a 80 00       	push   $0x800a47
  800ac0:	e8 92 fb ff ff       	call   800657 <vprintfmt>
  800ac5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800acb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad9:	8d 45 10             	lea    0x10(%ebp),%eax
  800adc:	83 c0 04             	add    $0x4,%eax
  800adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 89 ff ff ff       	call   800a7d <vsnprintf>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 06                	jmp    800b14 <strlen+0x15>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 f1                	jne    800b0e <strlen+0xf>
		n++;
	return n;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b2f:	eb 09                	jmp    800b3a <strnlen+0x18>
		n++;
  800b31:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b34:	ff 45 08             	incl   0x8(%ebp)
  800b37:	ff 4d 0c             	decl   0xc(%ebp)
  800b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3e:	74 09                	je     800b49 <strnlen+0x27>
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	75 e8                	jne    800b31 <strnlen+0xf>
		n++;
	return n;
  800b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b5a:	90                   	nop
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8d 50 01             	lea    0x1(%eax),%edx
  800b61:	89 55 08             	mov    %edx,0x8(%ebp)
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b6d:	8a 12                	mov    (%edx),%dl
  800b6f:	88 10                	mov    %dl,(%eax)
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e4                	jne    800b5b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 1f                	jmp    800bb0 <strncpy+0x34>
		*dst++ = *src;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8d 50 01             	lea    0x1(%eax),%edx
  800b97:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	8a 12                	mov    (%edx),%dl
  800b9f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	84 c0                	test   %al,%al
  800ba8:	74 03                	je     800bad <strncpy+0x31>
			src++;
  800baa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bad:	ff 45 fc             	incl   -0x4(%ebp)
  800bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bb6:	72 d9                	jb     800b91 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcd:	74 30                	je     800bff <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bcf:	eb 16                	jmp    800be7 <strlcpy+0x2a>
			*dst++ = *src++;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be3:	8a 12                	mov    (%edx),%dl
  800be5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be7:	ff 4d 10             	decl   0x10(%ebp)
  800bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bee:	74 09                	je     800bf9 <strlcpy+0x3c>
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	75 d8                	jne    800bd1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bff:	8b 55 08             	mov    0x8(%ebp),%edx
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c05:	29 c2                	sub    %eax,%edx
  800c07:	89 d0                	mov    %edx,%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c0e:	eb 06                	jmp    800c16 <strcmp+0xb>
		p++, q++;
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	74 0e                	je     800c2d <strcmp+0x22>
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 10                	mov    (%eax),%dl
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	38 c2                	cmp    %al,%dl
  800c2b:	74 e3                	je     800c10 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f b6 d0             	movzbl %al,%edx
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	29 c2                	sub    %eax,%edx
  800c3f:	89 d0                	mov    %edx,%eax
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c46:	eb 09                	jmp    800c51 <strncmp+0xe>
		n--, p++, q++;
  800c48:	ff 4d 10             	decl   0x10(%ebp)
  800c4b:	ff 45 08             	incl   0x8(%ebp)
  800c4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	74 17                	je     800c6e <strncmp+0x2b>
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 0e                	je     800c6e <strncmp+0x2b>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 10                	mov    (%eax),%dl
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	38 c2                	cmp    %al,%dl
  800c6c:	74 da                	je     800c48 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c72:	75 07                	jne    800c7b <strncmp+0x38>
		return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	eb 14                	jmp    800c8f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 d0             	movzbl %al,%edx
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	29 c2                	sub    %eax,%edx
  800c8d:	89 d0                	mov    %edx,%eax
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 04             	sub    $0x4,%esp
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9d:	eb 12                	jmp    800cb1 <strchr+0x20>
		if (*s == c)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca7:	75 05                	jne    800cae <strchr+0x1d>
			return (char *) s;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	eb 11                	jmp    800cbf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 e5                	jne    800c9f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccd:	eb 0d                	jmp    800cdc <strfind+0x1b>
		if (*s == c)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd7:	74 0e                	je     800ce7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 ea                	jne    800ccf <strfind+0xe>
  800ce5:	eb 01                	jmp    800ce8 <strfind+0x27>
		if (*s == c)
			break;
  800ce7:	90                   	nop
	return (char *) s;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cff:	eb 0e                	jmp    800d0f <memset+0x22>
		*p++ = c;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	8d 50 01             	lea    0x1(%eax),%edx
  800d07:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d0f:	ff 4d f8             	decl   -0x8(%ebp)
  800d12:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d16:	79 e9                	jns    800d01 <memset+0x14>
		*p++ = c;

	return v;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d2f:	eb 16                	jmp    800d47 <memcpy+0x2a>
		*d++ = *s++;
  800d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d40:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d43:	8a 12                	mov    (%edx),%dl
  800d45:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	75 dd                	jne    800d31 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d71:	73 50                	jae    800dc3 <memmove+0x6a>
  800d73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7e:	76 43                	jbe    800dc3 <memmove+0x6a>
		s += n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d8c:	eb 10                	jmp    800d9e <memmove+0x45>
			*--d = *--s;
  800d8e:	ff 4d f8             	decl   -0x8(%ebp)
  800d91:	ff 4d fc             	decl   -0x4(%ebp)
  800d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d97:	8a 10                	mov    (%eax),%dl
  800d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da4:	89 55 10             	mov    %edx,0x10(%ebp)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	75 e3                	jne    800d8e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dab:	eb 23                	jmp    800dd0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbf:	8a 12                	mov    (%edx),%dl
  800dc1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	75 dd                	jne    800dad <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de7:	eb 2a                	jmp    800e13 <memcmp+0x3e>
		if (*s1 != *s2)
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dec:	8a 10                	mov    (%eax),%dl
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	38 c2                	cmp    %al,%dl
  800df5:	74 16                	je     800e0d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	eb 18                	jmp    800e25 <memcmp+0x50>
		s1++, s2++;
  800e0d:	ff 45 fc             	incl   -0x4(%ebp)
  800e10:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 c9                	jne    800de9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	01 d0                	add    %edx,%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e38:	eb 15                	jmp    800e4f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f b6 d0             	movzbl %al,%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	0f b6 c0             	movzbl %al,%eax
  800e48:	39 c2                	cmp    %eax,%edx
  800e4a:	74 0d                	je     800e59 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e55:	72 e3                	jb     800e3a <memfind+0x13>
  800e57:	eb 01                	jmp    800e5a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e59:	90                   	nop
	return (void *) s;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e6c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e73:	eb 03                	jmp    800e78 <strtol+0x19>
		s++;
  800e75:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 20                	cmp    $0x20,%al
  800e7f:	74 f4                	je     800e75 <strtol+0x16>
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 09                	cmp    $0x9,%al
  800e88:	74 eb                	je     800e75 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 2b                	cmp    $0x2b,%al
  800e91:	75 05                	jne    800e98 <strtol+0x39>
		s++;
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	eb 13                	jmp    800eab <strtol+0x4c>
	else if (*s == '-')
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 2d                	cmp    $0x2d,%al
  800e9f:	75 0a                	jne    800eab <strtol+0x4c>
		s++, neg = 1;
  800ea1:	ff 45 08             	incl   0x8(%ebp)
  800ea4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	74 06                	je     800eb7 <strtol+0x58>
  800eb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb5:	75 20                	jne    800ed7 <strtol+0x78>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	3c 30                	cmp    $0x30,%al
  800ebe:	75 17                	jne    800ed7 <strtol+0x78>
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	40                   	inc    %eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3c 78                	cmp    $0x78,%al
  800ec8:	75 0d                	jne    800ed7 <strtol+0x78>
		s += 2, base = 16;
  800eca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ece:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed5:	eb 28                	jmp    800eff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ed7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edb:	75 15                	jne    800ef2 <strtol+0x93>
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 30                	cmp    $0x30,%al
  800ee4:	75 0c                	jne    800ef2 <strtol+0x93>
		s++, base = 8;
  800ee6:	ff 45 08             	incl   0x8(%ebp)
  800ee9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef0:	eb 0d                	jmp    800eff <strtol+0xa0>
	else if (base == 0)
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	75 07                	jne    800eff <strtol+0xa0>
		base = 10;
  800ef8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 2f                	cmp    $0x2f,%al
  800f06:	7e 19                	jle    800f21 <strtol+0xc2>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 39                	cmp    $0x39,%al
  800f0f:	7f 10                	jg     800f21 <strtol+0xc2>
			dig = *s - '0';
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f be c0             	movsbl %al,%eax
  800f19:	83 e8 30             	sub    $0x30,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1f:	eb 42                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 60                	cmp    $0x60,%al
  800f28:	7e 19                	jle    800f43 <strtol+0xe4>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 7a                	cmp    $0x7a,%al
  800f31:	7f 10                	jg     800f43 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f be c0             	movsbl %al,%eax
  800f3b:	83 e8 57             	sub    $0x57,%eax
  800f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f41:	eb 20                	jmp    800f63 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 40                	cmp    $0x40,%al
  800f4a:	7e 39                	jle    800f85 <strtol+0x126>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 5a                	cmp    $0x5a,%al
  800f53:	7f 30                	jg     800f85 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f be c0             	movsbl %al,%eax
  800f5d:	83 e8 37             	sub    $0x37,%eax
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f66:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f69:	7d 19                	jge    800f84 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f7f:	e9 7b ff ff ff       	jmp    800eff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f84:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f89:	74 08                	je     800f93 <strtol+0x134>
		*endptr = (char *) s;
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f97:	74 07                	je     800fa0 <strtol+0x141>
  800f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9c:	f7 d8                	neg    %eax
  800f9e:	eb 03                	jmp    800fa3 <strtol+0x144>
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <ltostr>:

void
ltostr(long value, char *str)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbd:	79 13                	jns    800fd2 <ltostr+0x2d>
	{
		neg = 1;
  800fbf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fcc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fcf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fda:	99                   	cltd   
  800fdb:	f7 f9                	idiv   %ecx
  800fdd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff3:	83 c2 30             	add    $0x30,%edx
  800ff6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ff8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ffb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801000:	f7 e9                	imul   %ecx
  801002:	c1 fa 02             	sar    $0x2,%edx
  801005:	89 c8                	mov    %ecx,%eax
  801007:	c1 f8 1f             	sar    $0x1f,%eax
  80100a:	29 c2                	sub    %eax,%edx
  80100c:	89 d0                	mov    %edx,%eax
  80100e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801011:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801014:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801019:	f7 e9                	imul   %ecx
  80101b:	c1 fa 02             	sar    $0x2,%edx
  80101e:	89 c8                	mov    %ecx,%eax
  801020:	c1 f8 1f             	sar    $0x1f,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
  801027:	c1 e0 02             	shl    $0x2,%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	01 c0                	add    %eax,%eax
  80102e:	29 c1                	sub    %eax,%ecx
  801030:	89 ca                	mov    %ecx,%edx
  801032:	85 d2                	test   %edx,%edx
  801034:	75 9c                	jne    800fd2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801036:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	48                   	dec    %eax
  801041:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801044:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801048:	74 3d                	je     801087 <ltostr+0xe2>
		start = 1 ;
  80104a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801051:	eb 34                	jmp    801087 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 d0                	add    %edx,%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	01 c2                	add    %eax,%edx
  801068:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	01 c8                	add    %ecx,%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	01 c2                	add    %eax,%edx
  80107c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80107f:	88 02                	mov    %al,(%edx)
		start++ ;
  801081:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801084:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80108d:	7c c4                	jl     801053 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80108f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 54 fa ff ff       	call   800aff <strlen>
  8010ab:	83 c4 04             	add    $0x4,%esp
  8010ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	e8 46 fa ff ff       	call   800aff <strlen>
  8010b9:	83 c4 04             	add    $0x4,%esp
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010cd:	eb 17                	jmp    8010e6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	01 c2                	add    %eax,%edx
  8010d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	01 c8                	add    %ecx,%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ec:	7c e1                	jl     8010cf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010fc:	eb 1f                	jmp    80111d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801107:	89 c2                	mov    %eax,%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c8                	add    %ecx,%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80111a:	ff 45 f8             	incl   -0x8(%ebp)
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801123:	7c d9                	jl     8010fe <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801125:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c6 00 00             	movb   $0x0,(%eax)
}
  801130:	90                   	nop
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801136:	8b 45 14             	mov    0x14(%ebp),%eax
  801139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	8b 00                	mov    (%eax),%eax
  801144:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801156:	eb 0c                	jmp    801164 <strsplit+0x31>
			*string++ = 0;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8d 50 01             	lea    0x1(%eax),%edx
  80115e:	89 55 08             	mov    %edx,0x8(%ebp)
  801161:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	84 c0                	test   %al,%al
  80116b:	74 18                	je     801185 <strsplit+0x52>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f be c0             	movsbl %al,%eax
  801175:	50                   	push   %eax
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	e8 13 fb ff ff       	call   800c91 <strchr>
  80117e:	83 c4 08             	add    $0x8,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	75 d3                	jne    801158 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	84 c0                	test   %al,%al
  80118c:	74 5a                	je     8011e8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80118e:	8b 45 14             	mov    0x14(%ebp),%eax
  801191:	8b 00                	mov    (%eax),%eax
  801193:	83 f8 0f             	cmp    $0xf,%eax
  801196:	75 07                	jne    80119f <strsplit+0x6c>
		{
			return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
  80119d:	eb 66                	jmp    801205 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80119f:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a2:	8b 00                	mov    (%eax),%eax
  8011a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a7:	8b 55 14             	mov    0x14(%ebp),%edx
  8011aa:	89 0a                	mov    %ecx,(%edx)
  8011ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 c2                	add    %eax,%edx
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011bd:	eb 03                	jmp    8011c2 <strsplit+0x8f>
			string++;
  8011bf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	74 8b                	je     801156 <strsplit+0x23>
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	50                   	push   %eax
  8011d4:	ff 75 0c             	pushl  0xc(%ebp)
  8011d7:	e8 b5 fa ff ff       	call   800c91 <strchr>
  8011dc:	83 c4 08             	add    $0x8,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 dc                	je     8011bf <strsplit+0x8c>
			string++;
	}
  8011e3:	e9 6e ff ff ff       	jmp    801156 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011e8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	8b 00                	mov    (%eax),%eax
  8011ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	01 d0                	add    %edx,%eax
  8011fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801200:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80120d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801214:	eb 4c                	jmp    801262 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801216:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 d0                	add    %edx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 40                	cmp    $0x40,%al
  801222:	7e 27                	jle    80124b <str2lower+0x44>
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	3c 5a                	cmp    $0x5a,%al
  801230:	7f 19                	jg     80124b <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801232:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	01 d0                	add    %edx,%eax
  80123a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80123d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801240:	01 ca                	add    %ecx,%edx
  801242:	8a 12                	mov    (%edx),%dl
  801244:	83 c2 20             	add    $0x20,%edx
  801247:	88 10                	mov    %dl,(%eax)
  801249:	eb 14                	jmp    80125f <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80124b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	01 c2                	add    %eax,%edx
  801253:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	01 c8                	add    %ecx,%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80125f:	ff 45 fc             	incl   -0x4(%ebp)
  801262:	ff 75 0c             	pushl  0xc(%ebp)
  801265:	e8 95 f8 ff ff       	call   800aff <strlen>
  80126a:	83 c4 04             	add    $0x4,%esp
  80126d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801270:	7f a4                	jg     801216 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
  80127f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8b 55 0c             	mov    0xc(%ebp),%edx
  801288:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80128b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80128e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801291:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801294:	cd 30                	int    $0x30
  801296:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801299:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    

008012a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	52                   	push   %edx
  8012bc:	ff 75 0c             	pushl  0xc(%ebp)
  8012bf:	50                   	push   %eax
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 b2 ff ff ff       	call   801279 <syscall>
  8012c7:	83 c4 18             	add    $0x18,%esp
}
  8012ca:	90                   	nop
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 01                	push   $0x1
  8012dc:	e8 98 ff ff ff       	call   801279 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	52                   	push   %edx
  8012f6:	50                   	push   %eax
  8012f7:	6a 05                	push   $0x5
  8012f9:	e8 7b ff ff ff       	call   801279 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801308:	8b 75 18             	mov    0x18(%ebp),%esi
  80130b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	56                   	push   %esi
  801318:	53                   	push   %ebx
  801319:	51                   	push   %ecx
  80131a:	52                   	push   %edx
  80131b:	50                   	push   %eax
  80131c:	6a 06                	push   $0x6
  80131e:	e8 56 ff ff ff       	call   801279 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801330:	8b 55 0c             	mov    0xc(%ebp),%edx
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	52                   	push   %edx
  80133d:	50                   	push   %eax
  80133e:	6a 07                	push   $0x7
  801340:	e8 34 ff ff ff       	call   801279 <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	ff 75 0c             	pushl  0xc(%ebp)
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	6a 08                	push   $0x8
  80135b:	e8 19 ff ff ff       	call   801279 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 09                	push   $0x9
  801374:	e8 00 ff ff ff       	call   801279 <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 0a                	push   $0xa
  80138d:	e8 e7 fe ff ff       	call   801279 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 0b                	push   $0xb
  8013a6:	e8 ce fe ff ff       	call   801279 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 0c                	push   $0xc
  8013bf:	e8 b5 fe ff ff       	call   801279 <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	ff 75 08             	pushl  0x8(%ebp)
  8013d7:	6a 0d                	push   $0xd
  8013d9:	e8 9b fe ff ff       	call   801279 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 0e                	push   $0xe
  8013f2:	e8 82 fe ff ff       	call   801279 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 11                	push   $0x11
  80140c:	e8 68 fe ff ff       	call   801279 <syscall>
  801411:	83 c4 18             	add    $0x18,%esp
}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 12                	push   $0x12
  801426:	e8 4e fe ff ff       	call   801279 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	90                   	nop
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_cputc>:


void
sys_cputc(const char c)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80143d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	50                   	push   %eax
  80144a:	6a 13                	push   $0x13
  80144c:	e8 28 fe ff ff       	call   801279 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 14                	push   $0x14
  801466:	e8 0e fe ff ff       	call   801279 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	50                   	push   %eax
  801481:	6a 15                	push   $0x15
  801483:	e8 f1 fd ff ff       	call   801279 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	52                   	push   %edx
  80149d:	50                   	push   %eax
  80149e:	6a 18                	push   $0x18
  8014a0:	e8 d4 fd ff ff       	call   801279 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	50                   	push   %eax
  8014bb:	6a 16                	push   $0x16
  8014bd:	e8 b7 fd ff ff       	call   801279 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	90                   	nop
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	52                   	push   %edx
  8014d8:	50                   	push   %eax
  8014d9:	6a 17                	push   $0x17
  8014db:	e8 99 fd ff ff       	call   801279 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	51                   	push   %ecx
  8014ff:	52                   	push   %edx
  801500:	ff 75 0c             	pushl  0xc(%ebp)
  801503:	50                   	push   %eax
  801504:	6a 19                	push   $0x19
  801506:	e8 6e fd ff ff       	call   801279 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	6a 1a                	push   $0x1a
  801523:	e8 51 fd ff ff       	call   801279 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801530:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	51                   	push   %ecx
  80153e:	52                   	push   %edx
  80153f:	50                   	push   %eax
  801540:	6a 1b                	push   $0x1b
  801542:	e8 32 fd ff ff       	call   801279 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	6a 1c                	push   $0x1c
  80155f:	e8 15 fd ff ff       	call   801279 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 1d                	push   $0x1d
  801578:	e8 fc fc ff ff       	call   801279 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	6a 00                	push   $0x0
  80158a:	ff 75 14             	pushl  0x14(%ebp)
  80158d:	ff 75 10             	pushl  0x10(%ebp)
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	50                   	push   %eax
  801594:	6a 1e                	push   $0x1e
  801596:	e8 de fc ff ff       	call   801279 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	50                   	push   %eax
  8015af:	6a 1f                	push   $0x1f
  8015b1:	e8 c3 fc ff ff       	call   801279 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	90                   	nop
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	50                   	push   %eax
  8015cb:	6a 20                	push   $0x20
  8015cd:	e8 a7 fc ff ff       	call   801279 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 02                	push   $0x2
  8015e6:	e8 8e fc ff ff       	call   801279 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 03                	push   $0x3
  8015ff:	e8 75 fc ff ff       	call   801279 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 04                	push   $0x4
  801618:	e8 5c fc ff ff       	call   801279 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_exit_env>:


void sys_exit_env(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 21                	push   $0x21
  801631:	e8 43 fc ff ff       	call   801279 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	90                   	nop
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801642:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801645:	8d 50 04             	lea    0x4(%eax),%edx
  801648:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	52                   	push   %edx
  801652:	50                   	push   %eax
  801653:	6a 22                	push   $0x22
  801655:	e8 1f fc ff ff       	call   801279 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
	return result;
  80165d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801660:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801663:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801666:	89 01                	mov    %eax,(%ecx)
  801668:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	c9                   	leave  
  80166f:	c2 04 00             	ret    $0x4

00801672 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	ff 75 10             	pushl  0x10(%ebp)
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	6a 10                	push   $0x10
  801684:	e8 f0 fb ff ff       	call   801279 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
	return ;
  80168c:	90                   	nop
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_rcr2>:
uint32 sys_rcr2()
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 23                	push   $0x23
  80169e:	e8 d6 fb ff ff       	call   801279 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	50                   	push   %eax
  8016c1:	6a 24                	push   $0x24
  8016c3:	e8 b1 fb ff ff       	call   801279 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cb:	90                   	nop
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <rsttst>:
void rsttst()
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 26                	push   $0x26
  8016dd:	e8 97 fb ff ff       	call   801279 <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e5:	90                   	nop
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8016f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016fb:	52                   	push   %edx
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 10             	pushl  0x10(%ebp)
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	6a 25                	push   $0x25
  801708:	e8 6c fb ff ff       	call   801279 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
	return ;
  801710:	90                   	nop
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <chktst>:
void chktst(uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	6a 27                	push   $0x27
  801723:	e8 51 fb ff ff       	call   801279 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
	return ;
  80172b:	90                   	nop
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <inctst>:

void inctst()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 28                	push   $0x28
  80173d:	e8 37 fb ff ff       	call   801279 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
	return ;
  801745:	90                   	nop
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <gettst>:
uint32 gettst()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 29                	push   $0x29
  801757:	e8 1d fb ff ff       	call   801279 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 2a                	push   $0x2a
  801773:	e8 01 fb ff ff       	call   801279 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
  80177b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80177e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801782:	75 07                	jne    80178b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801784:	b8 01 00 00 00       	mov    $0x1,%eax
  801789:	eb 05                	jmp    801790 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 2a                	push   $0x2a
  8017a4:	e8 d0 fa ff ff       	call   801279 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
  8017ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017b3:	75 07                	jne    8017bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ba:	eb 05                	jmp    8017c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 2a                	push   $0x2a
  8017d5:	e8 9f fa ff ff       	call   801279 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017e4:	75 07                	jne    8017ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017eb:	eb 05                	jmp    8017f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 2a                	push   $0x2a
  801806:	e8 6e fa ff ff       	call   801279 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
  80180e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801811:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801815:	75 07                	jne    80181e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801817:	b8 01 00 00 00       	mov    $0x1,%eax
  80181c:	eb 05                	jmp    801823 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 2b                	push   $0x2b
  801835:	e8 3f fa ff ff       	call   801279 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	53                   	push   %ebx
  801853:	51                   	push   %ecx
  801854:	52                   	push   %edx
  801855:	50                   	push   %eax
  801856:	6a 2c                	push   $0x2c
  801858:	e8 1c fa ff ff       	call   801279 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	50                   	push   %eax
  801876:	6a 2d                	push   $0x2d
  801878:	e8 fc f9 ff ff       	call   801279 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801885:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	51                   	push   %ecx
  801891:	ff 75 10             	pushl  0x10(%ebp)
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 2e                	push   $0x2e
  801898:	e8 dc f9 ff ff       	call   801279 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 10             	pushl  0x10(%ebp)
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	6a 0f                	push   $0xf
  8018b4:	e8 c0 f9 ff ff       	call   801279 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	50                   	push   %eax
  8018ce:	6a 2f                	push   $0x2f
  8018d0:	e8 a4 f9 ff ff       	call   801279 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp

}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	6a 30                	push   $0x30
  8018eb:	e8 89 f9 ff ff       	call   801279 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
	return;
  8018f3:	90                   	nop
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 31                	push   $0x31
  801907:	e8 6d f9 ff ff       	call   801279 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
	return;
  80190f:	90                   	nop
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 32                	push   $0x32
  801921:	e8 53 f9 ff ff       	call   801279 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    
  80192b:	90                   	nop

0080192c <__udivdi3>:
  80192c:	55                   	push   %ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	83 ec 1c             	sub    $0x1c,%esp
  801933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80193b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80193f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801943:	89 ca                	mov    %ecx,%edx
  801945:	89 f8                	mov    %edi,%eax
  801947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80194b:	85 f6                	test   %esi,%esi
  80194d:	75 2d                	jne    80197c <__udivdi3+0x50>
  80194f:	39 cf                	cmp    %ecx,%edi
  801951:	77 65                	ja     8019b8 <__udivdi3+0x8c>
  801953:	89 fd                	mov    %edi,%ebp
  801955:	85 ff                	test   %edi,%edi
  801957:	75 0b                	jne    801964 <__udivdi3+0x38>
  801959:	b8 01 00 00 00       	mov    $0x1,%eax
  80195e:	31 d2                	xor    %edx,%edx
  801960:	f7 f7                	div    %edi
  801962:	89 c5                	mov    %eax,%ebp
  801964:	31 d2                	xor    %edx,%edx
  801966:	89 c8                	mov    %ecx,%eax
  801968:	f7 f5                	div    %ebp
  80196a:	89 c1                	mov    %eax,%ecx
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	f7 f5                	div    %ebp
  801970:	89 cf                	mov    %ecx,%edi
  801972:	89 fa                	mov    %edi,%edx
  801974:	83 c4 1c             	add    $0x1c,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
  80197c:	39 ce                	cmp    %ecx,%esi
  80197e:	77 28                	ja     8019a8 <__udivdi3+0x7c>
  801980:	0f bd fe             	bsr    %esi,%edi
  801983:	83 f7 1f             	xor    $0x1f,%edi
  801986:	75 40                	jne    8019c8 <__udivdi3+0x9c>
  801988:	39 ce                	cmp    %ecx,%esi
  80198a:	72 0a                	jb     801996 <__udivdi3+0x6a>
  80198c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801990:	0f 87 9e 00 00 00    	ja     801a34 <__udivdi3+0x108>
  801996:	b8 01 00 00 00       	mov    $0x1,%eax
  80199b:	89 fa                	mov    %edi,%edx
  80199d:	83 c4 1c             	add    $0x1c,%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5f                   	pop    %edi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
  8019a5:	8d 76 00             	lea    0x0(%esi),%esi
  8019a8:	31 ff                	xor    %edi,%edi
  8019aa:	31 c0                	xor    %eax,%eax
  8019ac:	89 fa                	mov    %edi,%edx
  8019ae:	83 c4 1c             	add    $0x1c,%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5f                   	pop    %edi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    
  8019b6:	66 90                	xchg   %ax,%ax
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	f7 f7                	div    %edi
  8019bc:	31 ff                	xor    %edi,%edi
  8019be:	89 fa                	mov    %edi,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019cd:	89 eb                	mov    %ebp,%ebx
  8019cf:	29 fb                	sub    %edi,%ebx
  8019d1:	89 f9                	mov    %edi,%ecx
  8019d3:	d3 e6                	shl    %cl,%esi
  8019d5:	89 c5                	mov    %eax,%ebp
  8019d7:	88 d9                	mov    %bl,%cl
  8019d9:	d3 ed                	shr    %cl,%ebp
  8019db:	89 e9                	mov    %ebp,%ecx
  8019dd:	09 f1                	or     %esi,%ecx
  8019df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019e3:	89 f9                	mov    %edi,%ecx
  8019e5:	d3 e0                	shl    %cl,%eax
  8019e7:	89 c5                	mov    %eax,%ebp
  8019e9:	89 d6                	mov    %edx,%esi
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 ee                	shr    %cl,%esi
  8019ef:	89 f9                	mov    %edi,%ecx
  8019f1:	d3 e2                	shl    %cl,%edx
  8019f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019f7:	88 d9                	mov    %bl,%cl
  8019f9:	d3 e8                	shr    %cl,%eax
  8019fb:	09 c2                	or     %eax,%edx
  8019fd:	89 d0                	mov    %edx,%eax
  8019ff:	89 f2                	mov    %esi,%edx
  801a01:	f7 74 24 0c          	divl   0xc(%esp)
  801a05:	89 d6                	mov    %edx,%esi
  801a07:	89 c3                	mov    %eax,%ebx
  801a09:	f7 e5                	mul    %ebp
  801a0b:	39 d6                	cmp    %edx,%esi
  801a0d:	72 19                	jb     801a28 <__udivdi3+0xfc>
  801a0f:	74 0b                	je     801a1c <__udivdi3+0xf0>
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	31 ff                	xor    %edi,%edi
  801a15:	e9 58 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a20:	89 f9                	mov    %edi,%ecx
  801a22:	d3 e2                	shl    %cl,%edx
  801a24:	39 c2                	cmp    %eax,%edx
  801a26:	73 e9                	jae    801a11 <__udivdi3+0xe5>
  801a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a2b:	31 ff                	xor    %edi,%edi
  801a2d:	e9 40 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a32:	66 90                	xchg   %ax,%ax
  801a34:	31 c0                	xor    %eax,%eax
  801a36:	e9 37 ff ff ff       	jmp    801972 <__udivdi3+0x46>
  801a3b:	90                   	nop

00801a3c <__umoddi3>:
  801a3c:	55                   	push   %ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 1c             	sub    $0x1c,%esp
  801a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a5b:	89 f3                	mov    %esi,%ebx
  801a5d:	89 fa                	mov    %edi,%edx
  801a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a63:	89 34 24             	mov    %esi,(%esp)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	75 1a                	jne    801a84 <__umoddi3+0x48>
  801a6a:	39 f7                	cmp    %esi,%edi
  801a6c:	0f 86 a2 00 00 00    	jbe    801b14 <__umoddi3+0xd8>
  801a72:	89 c8                	mov    %ecx,%eax
  801a74:	89 f2                	mov    %esi,%edx
  801a76:	f7 f7                	div    %edi
  801a78:	89 d0                	mov    %edx,%eax
  801a7a:	31 d2                	xor    %edx,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	39 f0                	cmp    %esi,%eax
  801a86:	0f 87 ac 00 00 00    	ja     801b38 <__umoddi3+0xfc>
  801a8c:	0f bd e8             	bsr    %eax,%ebp
  801a8f:	83 f5 1f             	xor    $0x1f,%ebp
  801a92:	0f 84 ac 00 00 00    	je     801b44 <__umoddi3+0x108>
  801a98:	bf 20 00 00 00       	mov    $0x20,%edi
  801a9d:	29 ef                	sub    %ebp,%edi
  801a9f:	89 fe                	mov    %edi,%esi
  801aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aa5:	89 e9                	mov    %ebp,%ecx
  801aa7:	d3 e0                	shl    %cl,%eax
  801aa9:	89 d7                	mov    %edx,%edi
  801aab:	89 f1                	mov    %esi,%ecx
  801aad:	d3 ef                	shr    %cl,%edi
  801aaf:	09 c7                	or     %eax,%edi
  801ab1:	89 e9                	mov    %ebp,%ecx
  801ab3:	d3 e2                	shl    %cl,%edx
  801ab5:	89 14 24             	mov    %edx,(%esp)
  801ab8:	89 d8                	mov    %ebx,%eax
  801aba:	d3 e0                	shl    %cl,%eax
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac2:	d3 e0                	shl    %cl,%eax
  801ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acc:	89 f1                	mov    %esi,%ecx
  801ace:	d3 e8                	shr    %cl,%eax
  801ad0:	09 d0                	or     %edx,%eax
  801ad2:	d3 eb                	shr    %cl,%ebx
  801ad4:	89 da                	mov    %ebx,%edx
  801ad6:	f7 f7                	div    %edi
  801ad8:	89 d3                	mov    %edx,%ebx
  801ada:	f7 24 24             	mull   (%esp)
  801add:	89 c6                	mov    %eax,%esi
  801adf:	89 d1                	mov    %edx,%ecx
  801ae1:	39 d3                	cmp    %edx,%ebx
  801ae3:	0f 82 87 00 00 00    	jb     801b70 <__umoddi3+0x134>
  801ae9:	0f 84 91 00 00 00    	je     801b80 <__umoddi3+0x144>
  801aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  801af3:	29 f2                	sub    %esi,%edx
  801af5:	19 cb                	sbb    %ecx,%ebx
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801afd:	d3 e0                	shl    %cl,%eax
  801aff:	89 e9                	mov    %ebp,%ecx
  801b01:	d3 ea                	shr    %cl,%edx
  801b03:	09 d0                	or     %edx,%eax
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 eb                	shr    %cl,%ebx
  801b09:	89 da                	mov    %ebx,%edx
  801b0b:	83 c4 1c             	add    $0x1c,%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5f                   	pop    %edi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
  801b13:	90                   	nop
  801b14:	89 fd                	mov    %edi,%ebp
  801b16:	85 ff                	test   %edi,%edi
  801b18:	75 0b                	jne    801b25 <__umoddi3+0xe9>
  801b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1f:	31 d2                	xor    %edx,%edx
  801b21:	f7 f7                	div    %edi
  801b23:	89 c5                	mov    %eax,%ebp
  801b25:	89 f0                	mov    %esi,%eax
  801b27:	31 d2                	xor    %edx,%edx
  801b29:	f7 f5                	div    %ebp
  801b2b:	89 c8                	mov    %ecx,%eax
  801b2d:	f7 f5                	div    %ebp
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	e9 44 ff ff ff       	jmp    801a7a <__umoddi3+0x3e>
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	89 c8                	mov    %ecx,%eax
  801b3a:	89 f2                	mov    %esi,%edx
  801b3c:	83 c4 1c             	add    $0x1c,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    
  801b44:	3b 04 24             	cmp    (%esp),%eax
  801b47:	72 06                	jb     801b4f <__umoddi3+0x113>
  801b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b4d:	77 0f                	ja     801b5e <__umoddi3+0x122>
  801b4f:	89 f2                	mov    %esi,%edx
  801b51:	29 f9                	sub    %edi,%ecx
  801b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b57:	89 14 24             	mov    %edx,(%esp)
  801b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b62:	8b 14 24             	mov    (%esp),%edx
  801b65:	83 c4 1c             	add    $0x1c,%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    
  801b6d:	8d 76 00             	lea    0x0(%esi),%esi
  801b70:	2b 04 24             	sub    (%esp),%eax
  801b73:	19 fa                	sbb    %edi,%edx
  801b75:	89 d1                	mov    %edx,%ecx
  801b77:	89 c6                	mov    %eax,%esi
  801b79:	e9 71 ff ff ff       	jmp    801aef <__umoddi3+0xb3>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b84:	72 ea                	jb     801b70 <__umoddi3+0x134>
  801b86:	89 d9                	mov    %ebx,%ecx
  801b88:	e9 62 ff ff ff       	jmp    801aef <__umoddi3+0xb3>
