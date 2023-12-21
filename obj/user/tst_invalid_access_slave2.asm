
obj/user/tst_invalid_access_slave2:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] User address but READ-ONLY
	uint32 *ptr = (uint32*)USER_TOP;
  80003e:	c7 45 f4 00 00 c0 ee 	movl   $0xeec00000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 b0 16 00 00       	call   801703 <inctst>
	panic("tst invalid access failed: Attempt to write on a READ-ONLY user page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 80 1b 80 00       	push   $0x801b80
  80005b:	6a 0e                	push   $0xe
  80005d:	68 f8 1b 80 00       	push   $0x801bf8
  800062:	e8 2e 01 00 00       	call   800195 <_panic>

00800067 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 53 15 00 00       	call   8015c5 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	01 c0                	add    %eax,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c1 e0 06             	shl    $0x6,%eax
  800081:	29 d0                	sub    %edx,%eax
  800083:	c1 e0 03             	shl    $0x3,%eax
  800086:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800090:	a1 20 30 80 00       	mov    0x803020,%eax
  800095:	8a 40 68             	mov    0x68(%eax),%al
  800098:	84 c0                	test   %al,%al
  80009a:	74 0d                	je     8000a9 <libmain+0x42>
		binaryname = myEnv->prog_name;
  80009c:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a1:	83 c0 68             	add    $0x68,%eax
  8000a4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ad:	7e 0a                	jle    8000b9 <libmain+0x52>
		binaryname = argv[0];
  8000af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b2:	8b 00                	mov    (%eax),%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 0c             	pushl  0xc(%ebp)
  8000bf:	ff 75 08             	pushl  0x8(%ebp)
  8000c2:	e8 71 ff ff ff       	call   800038 <_main>
  8000c7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000ca:	e8 03 13 00 00       	call   8013d2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	68 34 1c 80 00       	push   $0x801c34
  8000d7:	e8 76 03 00 00       	call   800452 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000df:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e4:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	52                   	push   %edx
  8000f9:	50                   	push   %eax
  8000fa:	68 5c 1c 80 00       	push   $0x801c5c
  8000ff:	e8 4e 03 00 00       	call   800452 <cprintf>
  800104:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800107:	a1 20 30 80 00       	mov    0x803020,%eax
  80010c:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800112:	a1 20 30 80 00       	mov    0x803020,%eax
  800117:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800128:	51                   	push   %ecx
  800129:	52                   	push   %edx
  80012a:	50                   	push   %eax
  80012b:	68 84 1c 80 00       	push   $0x801c84
  800130:	e8 1d 03 00 00       	call   800452 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800138:	a1 20 30 80 00       	mov    0x803020,%eax
  80013d:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800143:	83 ec 08             	sub    $0x8,%esp
  800146:	50                   	push   %eax
  800147:	68 dc 1c 80 00       	push   $0x801cdc
  80014c:	e8 01 03 00 00       	call   800452 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 34 1c 80 00       	push   $0x801c34
  80015c:	e8 f1 02 00 00       	call   800452 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800164:	e8 83 12 00 00       	call   8013ec <sys_enable_interrupt>

	// exit gracefully
	exit();
  800169:	e8 19 00 00 00       	call   800187 <exit>
}
  80016e:	90                   	nop
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	6a 00                	push   $0x0
  80017c:	e8 10 14 00 00       	call   801591 <sys_destroy_env>
  800181:	83 c4 10             	add    $0x10,%esp
}
  800184:	90                   	nop
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <exit>:

void
exit(void)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018d:	e8 65 14 00 00       	call   8015f7 <sys_exit_env>
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80019b:	8d 45 10             	lea    0x10(%ebp),%eax
  80019e:	83 c0 04             	add    $0x4,%eax
  8001a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001a4:	a1 18 31 80 00       	mov    0x803118,%eax
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 16                	je     8001c3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001ad:	a1 18 31 80 00       	mov    0x803118,%eax
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	50                   	push   %eax
  8001b6:	68 f0 1c 80 00       	push   $0x801cf0
  8001bb:	e8 92 02 00 00       	call   800452 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001c3:	a1 00 30 80 00       	mov    0x803000,%eax
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	50                   	push   %eax
  8001cf:	68 f5 1c 80 00       	push   $0x801cf5
  8001d4:	e8 79 02 00 00       	call   800452 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e5:	50                   	push   %eax
  8001e6:	e8 fc 01 00 00       	call   8003e7 <vcprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	68 11 1d 80 00       	push   $0x801d11
  8001f8:	e8 ea 01 00 00       	call   8003e7 <vcprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800200:	e8 82 ff ff ff       	call   800187 <exit>

	// should not return here
	while (1) ;
  800205:	eb fe                	jmp    800205 <_panic+0x70>

00800207 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80020d:	a1 20 30 80 00       	mov    0x803020,%eax
  800212:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	39 c2                	cmp    %eax,%edx
  80021d:	74 14                	je     800233 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	68 14 1d 80 00       	push   $0x801d14
  800227:	6a 26                	push   $0x26
  800229:	68 60 1d 80 00       	push   $0x801d60
  80022e:	e8 62 ff ff ff       	call   800195 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80023a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800241:	e9 c5 00 00 00       	jmp    80030b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	01 d0                	add    %edx,%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	85 c0                	test   %eax,%eax
  800259:	75 08                	jne    800263 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80025b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80025e:	e9 a5 00 00 00       	jmp    800308 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800263:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80026a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800271:	eb 69                	jmp    8002dc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800273:	a1 20 30 80 00       	mov    0x803020,%eax
  800278:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80027e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800281:	89 d0                	mov    %edx,%eax
  800283:	01 c0                	add    %eax,%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c1 e0 03             	shl    $0x3,%eax
  80028a:	01 c8                	add    %ecx,%eax
  80028c:	8a 40 04             	mov    0x4(%eax),%al
  80028f:	84 c0                	test   %al,%al
  800291:	75 46                	jne    8002d9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800293:	a1 20 30 80 00       	mov    0x803020,%eax
  800298:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80029e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a1:	89 d0                	mov    %edx,%eax
  8002a3:	01 c0                	add    %eax,%eax
  8002a5:	01 d0                	add    %edx,%eax
  8002a7:	c1 e0 03             	shl    $0x3,%eax
  8002aa:	01 c8                	add    %ecx,%eax
  8002ac:	8b 00                	mov    (%eax),%eax
  8002ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c8:	01 c8                	add    %ecx,%eax
  8002ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	75 09                	jne    8002d9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002d7:	eb 15                	jmp    8002ee <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002d9:	ff 45 e8             	incl   -0x18(%ebp)
  8002dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e1:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8002e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ea:	39 c2                	cmp    %eax,%edx
  8002ec:	77 85                	ja     800273 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002f2:	75 14                	jne    800308 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 6c 1d 80 00       	push   $0x801d6c
  8002fc:	6a 3a                	push   $0x3a
  8002fe:	68 60 1d 80 00       	push   $0x801d60
  800303:	e8 8d fe ff ff       	call   800195 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800308:	ff 45 f0             	incl   -0x10(%ebp)
  80030b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800311:	0f 8c 2f ff ff ff    	jl     800246 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800317:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800325:	eb 26                	jmp    80034d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800327:	a1 20 30 80 00       	mov    0x803020,%eax
  80032c:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800332:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800335:	89 d0                	mov    %edx,%eax
  800337:	01 c0                	add    %eax,%eax
  800339:	01 d0                	add    %edx,%eax
  80033b:	c1 e0 03             	shl    $0x3,%eax
  80033e:	01 c8                	add    %ecx,%eax
  800340:	8a 40 04             	mov    0x4(%eax),%al
  800343:	3c 01                	cmp    $0x1,%al
  800345:	75 03                	jne    80034a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800347:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034a:	ff 45 e0             	incl   -0x20(%ebp)
  80034d:	a1 20 30 80 00       	mov    0x803020,%eax
  800352:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035b:	39 c2                	cmp    %eax,%edx
  80035d:	77 c8                	ja     800327 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80035f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800362:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800365:	74 14                	je     80037b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 c0 1d 80 00       	push   $0x801dc0
  80036f:	6a 44                	push   $0x44
  800371:	68 60 1d 80 00       	push   $0x801d60
  800376:	e8 1a fe ff ff       	call   800195 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	8d 48 01             	lea    0x1(%eax),%ecx
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 0a                	mov    %ecx,(%edx)
  800391:	8b 55 08             	mov    0x8(%ebp),%edx
  800394:	88 d1                	mov    %dl,%cl
  800396:	8b 55 0c             	mov    0xc(%ebp),%edx
  800399:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a7:	75 2c                	jne    8003d5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003a9:	a0 24 30 80 00       	mov    0x803024,%al
  8003ae:	0f b6 c0             	movzbl %al,%eax
  8003b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b4:	8b 12                	mov    (%edx),%edx
  8003b6:	89 d1                	mov    %edx,%ecx
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	83 c2 08             	add    $0x8,%edx
  8003be:	83 ec 04             	sub    $0x4,%esp
  8003c1:	50                   	push   %eax
  8003c2:	51                   	push   %ecx
  8003c3:	52                   	push   %edx
  8003c4:	e8 b0 0e 00 00       	call   801279 <sys_cputs>
  8003c9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 40 04             	mov    0x4(%eax),%eax
  8003db:	8d 50 01             	lea    0x1(%eax),%edx
  8003de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f7:	00 00 00 
	b.cnt = 0;
  8003fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800401:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800404:	ff 75 0c             	pushl  0xc(%ebp)
  800407:	ff 75 08             	pushl  0x8(%ebp)
  80040a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800410:	50                   	push   %eax
  800411:	68 7e 03 80 00       	push   $0x80037e
  800416:	e8 11 02 00 00       	call   80062c <vprintfmt>
  80041b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80041e:	a0 24 30 80 00       	mov    0x803024,%al
  800423:	0f b6 c0             	movzbl %al,%eax
  800426:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80042c:	83 ec 04             	sub    $0x4,%esp
  80042f:	50                   	push   %eax
  800430:	52                   	push   %edx
  800431:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800437:	83 c0 08             	add    $0x8,%eax
  80043a:	50                   	push   %eax
  80043b:	e8 39 0e 00 00       	call   801279 <sys_cputs>
  800440:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800443:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80044a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800450:	c9                   	leave  
  800451:	c3                   	ret    

00800452 <cprintf>:

int cprintf(const char *fmt, ...) {
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800458:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80045f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800462:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	ff 75 f4             	pushl  -0xc(%ebp)
  80046e:	50                   	push   %eax
  80046f:	e8 73 ff ff ff       	call   8003e7 <vcprintf>
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80047a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800485:	e8 48 0f 00 00       	call   8013d2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 f4             	pushl  -0xc(%ebp)
  800499:	50                   	push   %eax
  80049a:	e8 48 ff ff ff       	call   8003e7 <vcprintf>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004a5:	e8 42 0f 00 00       	call   8013ec <sys_enable_interrupt>
	return cnt;
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	53                   	push   %ebx
  8004b3:	83 ec 14             	sub    $0x14,%esp
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cd:	77 55                	ja     800524 <printnum+0x75>
  8004cf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d2:	72 05                	jb     8004d9 <printnum+0x2a>
  8004d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d7:	77 4b                	ja     800524 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004df:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e7:	52                   	push   %edx
  8004e8:	50                   	push   %eax
  8004e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8004ef:	e8 28 14 00 00       	call   80191c <__udivdi3>
  8004f4:	83 c4 10             	add    $0x10,%esp
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	ff 75 20             	pushl  0x20(%ebp)
  8004fd:	53                   	push   %ebx
  8004fe:	ff 75 18             	pushl  0x18(%ebp)
  800501:	52                   	push   %edx
  800502:	50                   	push   %eax
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 a1 ff ff ff       	call   8004af <printnum>
  80050e:	83 c4 20             	add    $0x20,%esp
  800511:	eb 1a                	jmp    80052d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	ff 75 0c             	pushl  0xc(%ebp)
  800519:	ff 75 20             	pushl  0x20(%ebp)
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	ff d0                	call   *%eax
  800521:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800524:	ff 4d 1c             	decl   0x1c(%ebp)
  800527:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052b:	7f e6                	jg     800513 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800530:	bb 00 00 00 00       	mov    $0x0,%ebx
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053b:	53                   	push   %ebx
  80053c:	51                   	push   %ecx
  80053d:	52                   	push   %edx
  80053e:	50                   	push   %eax
  80053f:	e8 e8 14 00 00       	call   801a2c <__umoddi3>
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	05 34 20 80 00       	add    $0x802034,%eax
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f be c0             	movsbl %al,%eax
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	ff 75 0c             	pushl  0xc(%ebp)
  800557:	50                   	push   %eax
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	ff d0                	call   *%eax
  80055d:	83 c4 10             	add    $0x10,%esp
}
  800560:	90                   	nop
  800561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800569:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80056d:	7e 1c                	jle    80058b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	8d 50 08             	lea    0x8(%eax),%edx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	89 10                	mov    %edx,(%eax)
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	83 e8 08             	sub    $0x8,%eax
  800584:	8b 50 04             	mov    0x4(%eax),%edx
  800587:	8b 00                	mov    (%eax),%eax
  800589:	eb 40                	jmp    8005cb <getuint+0x65>
	else if (lflag)
  80058b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80058f:	74 1e                	je     8005af <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	8d 50 04             	lea    0x4(%eax),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	89 10                	mov    %edx,(%eax)
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	83 e8 04             	sub    $0x4,%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	eb 1c                	jmp    8005cb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	8d 50 04             	lea    0x4(%eax),%edx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	89 10                	mov    %edx,(%eax)
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	83 e8 04             	sub    $0x4,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005cb:	5d                   	pop    %ebp
  8005cc:	c3                   	ret    

008005cd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d4:	7e 1c                	jle    8005f2 <getint+0x25>
		return va_arg(*ap, long long);
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	8d 50 08             	lea    0x8(%eax),%edx
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	89 10                	mov    %edx,(%eax)
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	83 e8 08             	sub    $0x8,%eax
  8005eb:	8b 50 04             	mov    0x4(%eax),%edx
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	eb 38                	jmp    80062a <getint+0x5d>
	else if (lflag)
  8005f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f6:	74 1a                	je     800612 <getint+0x45>
		return va_arg(*ap, long);
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	8d 50 04             	lea    0x4(%eax),%edx
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	89 10                	mov    %edx,(%eax)
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	83 e8 04             	sub    $0x4,%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	99                   	cltd   
  800610:	eb 18                	jmp    80062a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	8d 50 04             	lea    0x4(%eax),%edx
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	89 10                	mov    %edx,(%eax)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	83 e8 04             	sub    $0x4,%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	99                   	cltd   
}
  80062a:	5d                   	pop    %ebp
  80062b:	c3                   	ret    

0080062c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	56                   	push   %esi
  800630:	53                   	push   %ebx
  800631:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800634:	eb 17                	jmp    80064d <vprintfmt+0x21>
			if (ch == '\0')
  800636:	85 db                	test   %ebx,%ebx
  800638:	0f 84 af 03 00 00    	je     8009ed <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	53                   	push   %ebx
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	ff d0                	call   *%eax
  80064a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	8d 50 01             	lea    0x1(%eax),%edx
  800653:	89 55 10             	mov    %edx,0x10(%ebp)
  800656:	8a 00                	mov    (%eax),%al
  800658:	0f b6 d8             	movzbl %al,%ebx
  80065b:	83 fb 25             	cmp    $0x25,%ebx
  80065e:	75 d6                	jne    800636 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800660:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800664:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80066b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800672:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800679:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800680:	8b 45 10             	mov    0x10(%ebp),%eax
  800683:	8d 50 01             	lea    0x1(%eax),%edx
  800686:	89 55 10             	mov    %edx,0x10(%ebp)
  800689:	8a 00                	mov    (%eax),%al
  80068b:	0f b6 d8             	movzbl %al,%ebx
  80068e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800691:	83 f8 55             	cmp    $0x55,%eax
  800694:	0f 87 2b 03 00 00    	ja     8009c5 <vprintfmt+0x399>
  80069a:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006a1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006a3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a7:	eb d7                	jmp    800680 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ad:	eb d1                	jmp    800680 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	c1 e0 02             	shl    $0x2,%eax
  8006be:	01 d0                	add    %edx,%eax
  8006c0:	01 c0                	add    %eax,%eax
  8006c2:	01 d8                	add    %ebx,%eax
  8006c4:	83 e8 30             	sub    $0x30,%eax
  8006c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cd:	8a 00                	mov    (%eax),%al
  8006cf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d5:	7e 3e                	jle    800715 <vprintfmt+0xe9>
  8006d7:	83 fb 39             	cmp    $0x39,%ebx
  8006da:	7f 39                	jg     800715 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006dc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006df:	eb d5                	jmp    8006b6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f5:	eb 1f                	jmp    800716 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fb:	79 83                	jns    800680 <vprintfmt+0x54>
				width = 0;
  8006fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800704:	e9 77 ff ff ff       	jmp    800680 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800709:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800710:	e9 6b ff ff ff       	jmp    800680 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800715:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800716:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071a:	0f 89 60 ff ff ff    	jns    800680 <vprintfmt+0x54>
				width = precision, precision = -1;
  800720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800726:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80072d:	e9 4e ff ff ff       	jmp    800680 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800732:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800735:	e9 46 ff ff ff       	jmp    800680 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	83 c0 04             	add    $0x4,%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	50                   	push   %eax
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
			break;
  80075a:	e9 89 02 00 00       	jmp    8009e8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 e8 04             	sub    $0x4,%eax
  80076e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800770:	85 db                	test   %ebx,%ebx
  800772:	79 02                	jns    800776 <vprintfmt+0x14a>
				err = -err;
  800774:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800776:	83 fb 64             	cmp    $0x64,%ebx
  800779:	7f 0b                	jg     800786 <vprintfmt+0x15a>
  80077b:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800782:	85 f6                	test   %esi,%esi
  800784:	75 19                	jne    80079f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800786:	53                   	push   %ebx
  800787:	68 45 20 80 00       	push   $0x802045
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	e8 5e 02 00 00       	call   8009f5 <printfmt>
  800797:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80079a:	e9 49 02 00 00       	jmp    8009e8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80079f:	56                   	push   %esi
  8007a0:	68 4e 20 80 00       	push   $0x80204e
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	e8 45 02 00 00       	call   8009f5 <printfmt>
  8007b0:	83 c4 10             	add    $0x10,%esp
			break;
  8007b3:	e9 30 02 00 00       	jmp    8009e8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	83 c0 04             	add    $0x4,%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 30                	mov    (%eax),%esi
  8007c9:	85 f6                	test   %esi,%esi
  8007cb:	75 05                	jne    8007d2 <vprintfmt+0x1a6>
				p = "(null)";
  8007cd:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d6:	7e 6d                	jle    800845 <vprintfmt+0x219>
  8007d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007dc:	74 67                	je     800845 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	50                   	push   %eax
  8007e5:	56                   	push   %esi
  8007e6:	e8 0c 03 00 00       	call   800af7 <strnlen>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f1:	eb 16                	jmp    800809 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007f3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	50                   	push   %eax
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800806:	ff 4d e4             	decl   -0x1c(%ebp)
  800809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080d:	7f e4                	jg     8007f3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080f:	eb 34                	jmp    800845 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800811:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800815:	74 1c                	je     800833 <vprintfmt+0x207>
  800817:	83 fb 1f             	cmp    $0x1f,%ebx
  80081a:	7e 05                	jle    800821 <vprintfmt+0x1f5>
  80081c:	83 fb 7e             	cmp    $0x7e,%ebx
  80081f:	7e 12                	jle    800833 <vprintfmt+0x207>
					putch('?', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 3f                	push   $0x3f
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	eb 0f                	jmp    800842 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	53                   	push   %ebx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800842:	ff 4d e4             	decl   -0x1c(%ebp)
  800845:	89 f0                	mov    %esi,%eax
  800847:	8d 70 01             	lea    0x1(%eax),%esi
  80084a:	8a 00                	mov    (%eax),%al
  80084c:	0f be d8             	movsbl %al,%ebx
  80084f:	85 db                	test   %ebx,%ebx
  800851:	74 24                	je     800877 <vprintfmt+0x24b>
  800853:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800857:	78 b8                	js     800811 <vprintfmt+0x1e5>
  800859:	ff 4d e0             	decl   -0x20(%ebp)
  80085c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800860:	79 af                	jns    800811 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800862:	eb 13                	jmp    800877 <vprintfmt+0x24b>
				putch(' ', putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	6a 20                	push   $0x20
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800874:	ff 4d e4             	decl   -0x1c(%ebp)
  800877:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087b:	7f e7                	jg     800864 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80087d:	e9 66 01 00 00       	jmp    8009e8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 e8             	pushl  -0x18(%ebp)
  800888:	8d 45 14             	lea    0x14(%ebp),%eax
  80088b:	50                   	push   %eax
  80088c:	e8 3c fd ff ff       	call   8005cd <getint>
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800897:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80089a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a0:	85 d2                	test   %edx,%edx
  8008a2:	79 23                	jns    8008c7 <vprintfmt+0x29b>
				putch('-', putdat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	6a 2d                	push   $0x2d
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ba:	f7 d8                	neg    %eax
  8008bc:	83 d2 00             	adc    $0x0,%edx
  8008bf:	f7 da                	neg    %edx
  8008c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ce:	e9 bc 00 00 00       	jmp    80098f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008dc:	50                   	push   %eax
  8008dd:	e8 84 fc ff ff       	call   800566 <getuint>
  8008e2:	83 c4 10             	add    $0x10,%esp
  8008e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f2:	e9 98 00 00 00       	jmp    80098f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 58                	push   $0x58
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	6a 58                	push   $0x58
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	6a 58                	push   $0x58
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	ff d0                	call   *%eax
  800924:	83 c4 10             	add    $0x10,%esp
			break;
  800927:	e9 bc 00 00 00       	jmp    8009e8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	6a 30                	push   $0x30
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	ff d0                	call   *%eax
  800939:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	6a 78                	push   $0x78
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 c0 04             	add    $0x4,%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80095d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800967:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80096e:	eb 1f                	jmp    80098f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 e8             	pushl  -0x18(%ebp)
  800976:	8d 45 14             	lea    0x14(%ebp),%eax
  800979:	50                   	push   %eax
  80097a:	e8 e7 fb ff ff       	call   800566 <getuint>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800985:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80098f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	52                   	push   %edx
  80099a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80099d:	50                   	push   %eax
  80099e:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 00 fb ff ff       	call   8004af <printnum>
  8009af:	83 c4 20             	add    $0x20,%esp
			break;
  8009b2:	eb 34                	jmp    8009e8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	ff d0                	call   *%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
			break;
  8009c3:	eb 23                	jmp    8009e8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 25                	push   $0x25
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d5:	ff 4d 10             	decl   0x10(%ebp)
  8009d8:	eb 03                	jmp    8009dd <vprintfmt+0x3b1>
  8009da:	ff 4d 10             	decl   0x10(%ebp)
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	48                   	dec    %eax
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	3c 25                	cmp    $0x25,%al
  8009e5:	75 f3                	jne    8009da <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009e7:	90                   	nop
		}
	}
  8009e8:	e9 47 fc ff ff       	jmp    800634 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ed:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8009fe:	83 c0 04             	add    $0x4,%eax
  800a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 16 fc ff ff       	call   80062c <vprintfmt>
  800a16:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a19:	90                   	nop
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a22:	8b 40 08             	mov    0x8(%eax),%eax
  800a25:	8d 50 01             	lea    0x1(%eax),%edx
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8b 10                	mov    (%eax),%edx
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 40 04             	mov    0x4(%eax),%eax
  800a39:	39 c2                	cmp    %eax,%edx
  800a3b:	73 12                	jae    800a4f <sprintputch+0x33>
		*b->buf++ = ch;
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	8d 48 01             	lea    0x1(%eax),%ecx
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a48:	89 0a                	mov    %ecx,(%edx)
  800a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4d:	88 10                	mov    %dl,(%eax)
}
  800a4f:	90                   	nop
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	01 d0                	add    %edx,%eax
  800a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a77:	74 06                	je     800a7f <vsnprintf+0x2d>
  800a79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7d:	7f 07                	jg     800a86 <vsnprintf+0x34>
		return -E_INVAL;
  800a7f:	b8 03 00 00 00       	mov    $0x3,%eax
  800a84:	eb 20                	jmp    800aa6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a86:	ff 75 14             	pushl  0x14(%ebp)
  800a89:	ff 75 10             	pushl  0x10(%ebp)
  800a8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	68 1c 0a 80 00       	push   $0x800a1c
  800a95:	e8 92 fb ff ff       	call   80062c <vprintfmt>
  800a9a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aae:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab1:	83 c0 04             	add    $0x4,%eax
  800ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aba:	ff 75 f4             	pushl  -0xc(%ebp)
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 89 ff ff ff       	call   800a52 <vsnprintf>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    

00800ad4 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae1:	eb 06                	jmp    800ae9 <strlen+0x15>
		n++;
  800ae3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae6:	ff 45 08             	incl   0x8(%ebp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8a 00                	mov    (%eax),%al
  800aee:	84 c0                	test   %al,%al
  800af0:	75 f1                	jne    800ae3 <strlen+0xf>
		n++;
	return n;
  800af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b04:	eb 09                	jmp    800b0f <strnlen+0x18>
		n++;
  800b06:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b09:	ff 45 08             	incl   0x8(%ebp)
  800b0c:	ff 4d 0c             	decl   0xc(%ebp)
  800b0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b13:	74 09                	je     800b1e <strnlen+0x27>
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	75 e8                	jne    800b06 <strnlen+0xf>
		n++;
	return n;
  800b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b2f:	90                   	nop
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8d 50 01             	lea    0x1(%eax),%edx
  800b36:	89 55 08             	mov    %edx,0x8(%ebp)
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b42:	8a 12                	mov    (%edx),%dl
  800b44:	88 10                	mov    %dl,(%eax)
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	84 c0                	test   %al,%al
  800b4a:	75 e4                	jne    800b30 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b64:	eb 1f                	jmp    800b85 <strncpy+0x34>
		*dst++ = *src;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8d 50 01             	lea    0x1(%eax),%edx
  800b6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	8a 12                	mov    (%edx),%dl
  800b74:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	84 c0                	test   %al,%al
  800b7d:	74 03                	je     800b82 <strncpy+0x31>
			src++;
  800b7f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b82:	ff 45 fc             	incl   -0x4(%ebp)
  800b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b88:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b8b:	72 d9                	jb     800b66 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba2:	74 30                	je     800bd4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba4:	eb 16                	jmp    800bbc <strlcpy+0x2a>
			*dst++ = *src++;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8d 50 01             	lea    0x1(%eax),%edx
  800bac:	89 55 08             	mov    %edx,0x8(%ebp)
  800baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bb8:	8a 12                	mov    (%edx),%dl
  800bba:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bbc:	ff 4d 10             	decl   0x10(%ebp)
  800bbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc3:	74 09                	je     800bce <strlcpy+0x3c>
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	75 d8                	jne    800ba6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bda:	29 c2                	sub    %eax,%edx
  800bdc:	89 d0                	mov    %edx,%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be3:	eb 06                	jmp    800beb <strcmp+0xb>
		p++, q++;
  800be5:	ff 45 08             	incl   0x8(%ebp)
  800be8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	84 c0                	test   %al,%al
  800bf2:	74 0e                	je     800c02 <strcmp+0x22>
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8a 10                	mov    (%eax),%dl
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	38 c2                	cmp    %al,%dl
  800c00:	74 e3                	je     800be5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	0f b6 d0             	movzbl %al,%edx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 c0             	movzbl %al,%eax
  800c12:	29 c2                	sub    %eax,%edx
  800c14:	89 d0                	mov    %edx,%eax
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c1b:	eb 09                	jmp    800c26 <strncmp+0xe>
		n--, p++, q++;
  800c1d:	ff 4d 10             	decl   0x10(%ebp)
  800c20:	ff 45 08             	incl   0x8(%ebp)
  800c23:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2a:	74 17                	je     800c43 <strncmp+0x2b>
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	84 c0                	test   %al,%al
  800c33:	74 0e                	je     800c43 <strncmp+0x2b>
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 10                	mov    (%eax),%dl
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	38 c2                	cmp    %al,%dl
  800c41:	74 da                	je     800c1d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c47:	75 07                	jne    800c50 <strncmp+0x38>
		return 0;
  800c49:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4e:	eb 14                	jmp    800c64 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d0             	movzbl %al,%edx
  800c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 c0             	movzbl %al,%eax
  800c60:	29 c2                	sub    %eax,%edx
  800c62:	89 d0                	mov    %edx,%eax
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 04             	sub    $0x4,%esp
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c72:	eb 12                	jmp    800c86 <strchr+0x20>
		if (*s == c)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7c:	75 05                	jne    800c83 <strchr+0x1d>
			return (char *) s;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	eb 11                	jmp    800c94 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c83:	ff 45 08             	incl   0x8(%ebp)
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	84 c0                	test   %al,%al
  800c8d:	75 e5                	jne    800c74 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 04             	sub    $0x4,%esp
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca2:	eb 0d                	jmp    800cb1 <strfind+0x1b>
		if (*s == c)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cac:	74 0e                	je     800cbc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	84 c0                	test   %al,%al
  800cb8:	75 ea                	jne    800ca4 <strfind+0xe>
  800cba:	eb 01                	jmp    800cbd <strfind+0x27>
		if (*s == c)
			break;
  800cbc:	90                   	nop
	return (char *) s;
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd4:	eb 0e                	jmp    800ce4 <memset+0x22>
		*p++ = c;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce4:	ff 4d f8             	decl   -0x8(%ebp)
  800ce7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ceb:	79 e9                	jns    800cd6 <memset+0x14>
		*p++ = c;

	return v;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d04:	eb 16                	jmp    800d1c <memcpy+0x2a>
		*d++ = *s++;
  800d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d15:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d18:	8a 12                	mov    (%edx),%dl
  800d1a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d22:	89 55 10             	mov    %edx,0x10(%ebp)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	75 dd                	jne    800d06 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d46:	73 50                	jae    800d98 <memmove+0x6a>
  800d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4e:	01 d0                	add    %edx,%eax
  800d50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d53:	76 43                	jbe    800d98 <memmove+0x6a>
		s += n;
  800d55:	8b 45 10             	mov    0x10(%ebp),%eax
  800d58:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d61:	eb 10                	jmp    800d73 <memmove+0x45>
			*--d = *--s;
  800d63:	ff 4d f8             	decl   -0x8(%ebp)
  800d66:	ff 4d fc             	decl   -0x4(%ebp)
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6c:	8a 10                	mov    (%eax),%dl
  800d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d71:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d79:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	75 e3                	jne    800d63 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d80:	eb 23                	jmp    800da5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	75 dd                	jne    800d82 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dbc:	eb 2a                	jmp    800de8 <memcmp+0x3e>
		if (*s1 != *s2)
  800dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc1:	8a 10                	mov    (%eax),%dl
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	38 c2                	cmp    %al,%dl
  800dca:	74 16                	je     800de2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	0f b6 d0             	movzbl %al,%edx
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 c0             	movzbl %al,%eax
  800ddc:	29 c2                	sub    %eax,%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	eb 18                	jmp    800dfa <memcmp+0x50>
		s1++, s2++;
  800de2:	ff 45 fc             	incl   -0x4(%ebp)
  800de5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800de8:	8b 45 10             	mov    0x10(%ebp),%eax
  800deb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dee:	89 55 10             	mov    %edx,0x10(%ebp)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	75 c9                	jne    800dbe <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	01 d0                	add    %edx,%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e0d:	eb 15                	jmp    800e24 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f b6 d0             	movzbl %al,%edx
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	0f b6 c0             	movzbl %al,%eax
  800e1d:	39 c2                	cmp    %eax,%edx
  800e1f:	74 0d                	je     800e2e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e21:	ff 45 08             	incl   0x8(%ebp)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e2a:	72 e3                	jb     800e0f <memfind+0x13>
  800e2c:	eb 01                	jmp    800e2f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e2e:	90                   	nop
	return (void *) s;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e48:	eb 03                	jmp    800e4d <strtol+0x19>
		s++;
  800e4a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	3c 20                	cmp    $0x20,%al
  800e54:	74 f4                	je     800e4a <strtol+0x16>
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3c 09                	cmp    $0x9,%al
  800e5d:	74 eb                	je     800e4a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 2b                	cmp    $0x2b,%al
  800e66:	75 05                	jne    800e6d <strtol+0x39>
		s++;
  800e68:	ff 45 08             	incl   0x8(%ebp)
  800e6b:	eb 13                	jmp    800e80 <strtol+0x4c>
	else if (*s == '-')
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	3c 2d                	cmp    $0x2d,%al
  800e74:	75 0a                	jne    800e80 <strtol+0x4c>
		s++, neg = 1;
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e84:	74 06                	je     800e8c <strtol+0x58>
  800e86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e8a:	75 20                	jne    800eac <strtol+0x78>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	3c 30                	cmp    $0x30,%al
  800e93:	75 17                	jne    800eac <strtol+0x78>
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	40                   	inc    %eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3c 78                	cmp    $0x78,%al
  800e9d:	75 0d                	jne    800eac <strtol+0x78>
		s += 2, base = 16;
  800e9f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eaa:	eb 28                	jmp    800ed4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	75 15                	jne    800ec7 <strtol+0x93>
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 30                	cmp    $0x30,%al
  800eb9:	75 0c                	jne    800ec7 <strtol+0x93>
		s++, base = 8;
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec5:	eb 0d                	jmp    800ed4 <strtol+0xa0>
	else if (base == 0)
  800ec7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecb:	75 07                	jne    800ed4 <strtol+0xa0>
		base = 10;
  800ecd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	3c 2f                	cmp    $0x2f,%al
  800edb:	7e 19                	jle    800ef6 <strtol+0xc2>
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 39                	cmp    $0x39,%al
  800ee4:	7f 10                	jg     800ef6 <strtol+0xc2>
			dig = *s - '0';
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	0f be c0             	movsbl %al,%eax
  800eee:	83 e8 30             	sub    $0x30,%eax
  800ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef4:	eb 42                	jmp    800f38 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3c 60                	cmp    $0x60,%al
  800efd:	7e 19                	jle    800f18 <strtol+0xe4>
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 7a                	cmp    $0x7a,%al
  800f06:	7f 10                	jg     800f18 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f be c0             	movsbl %al,%eax
  800f10:	83 e8 57             	sub    $0x57,%eax
  800f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f16:	eb 20                	jmp    800f38 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3c 40                	cmp    $0x40,%al
  800f1f:	7e 39                	jle    800f5a <strtol+0x126>
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 5a                	cmp    $0x5a,%al
  800f28:	7f 30                	jg     800f5a <strtol+0x126>
			dig = *s - 'A' + 10;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f be c0             	movsbl %al,%eax
  800f32:	83 e8 37             	sub    $0x37,%eax
  800f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f3e:	7d 19                	jge    800f59 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f46:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4a:	89 c2                	mov    %eax,%edx
  800f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4f:	01 d0                	add    %edx,%eax
  800f51:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f54:	e9 7b ff ff ff       	jmp    800ed4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f59:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5e:	74 08                	je     800f68 <strtol+0x134>
		*endptr = (char *) s;
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f6c:	74 07                	je     800f75 <strtol+0x141>
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	f7 d8                	neg    %eax
  800f73:	eb 03                	jmp    800f78 <strtol+0x144>
  800f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <ltostr>:

void
ltostr(long value, char *str)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f92:	79 13                	jns    800fa7 <ltostr+0x2d>
	{
		neg = 1;
  800f94:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800faf:	99                   	cltd   
  800fb0:	f7 f9                	idiv   %ecx
  800fb2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8d 50 01             	lea    0x1(%eax),%edx
  800fbb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	01 d0                	add    %edx,%eax
  800fc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc8:	83 c2 30             	add    $0x30,%edx
  800fcb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd5:	f7 e9                	imul   %ecx
  800fd7:	c1 fa 02             	sar    $0x2,%edx
  800fda:	89 c8                	mov    %ecx,%eax
  800fdc:	c1 f8 1f             	sar    $0x1f,%eax
  800fdf:	29 c2                	sub    %eax,%edx
  800fe1:	89 d0                	mov    %edx,%eax
  800fe3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fe6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fee:	f7 e9                	imul   %ecx
  800ff0:	c1 fa 02             	sar    $0x2,%edx
  800ff3:	89 c8                	mov    %ecx,%eax
  800ff5:	c1 f8 1f             	sar    $0x1f,%eax
  800ff8:	29 c2                	sub    %eax,%edx
  800ffa:	89 d0                	mov    %edx,%eax
  800ffc:	c1 e0 02             	shl    $0x2,%eax
  800fff:	01 d0                	add    %edx,%eax
  801001:	01 c0                	add    %eax,%eax
  801003:	29 c1                	sub    %eax,%ecx
  801005:	89 ca                	mov    %ecx,%edx
  801007:	85 d2                	test   %edx,%edx
  801009:	75 9c                	jne    800fa7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	48                   	dec    %eax
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801019:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101d:	74 3d                	je     80105c <ltostr+0xe2>
		start = 1 ;
  80101f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801026:	eb 34                	jmp    80105c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	01 d0                	add    %edx,%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	01 c2                	add    %eax,%edx
  80103d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c8                	add    %ecx,%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801049:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	01 c2                	add    %eax,%edx
  801051:	8a 45 eb             	mov    -0x15(%ebp),%al
  801054:	88 02                	mov    %al,(%edx)
		start++ ;
  801056:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801059:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801062:	7c c4                	jl     801028 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801064:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 d0                	add    %edx,%eax
  80106c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106f:	90                   	nop
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801078:	ff 75 08             	pushl  0x8(%ebp)
  80107b:	e8 54 fa ff ff       	call   800ad4 <strlen>
  801080:	83 c4 04             	add    $0x4,%esp
  801083:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	e8 46 fa ff ff       	call   800ad4 <strlen>
  80108e:	83 c4 04             	add    $0x4,%esp
  801091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a2:	eb 17                	jmp    8010bb <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 c2                	add    %eax,%edx
  8010ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	01 c8                	add    %ecx,%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b8:	ff 45 fc             	incl   -0x4(%ebp)
  8010bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c1:	7c e1                	jl     8010a4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d1:	eb 1f                	jmp    8010f2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	8d 50 01             	lea    0x1(%eax),%edx
  8010d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010dc:	89 c2                	mov    %eax,%edx
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	01 c2                	add    %eax,%edx
  8010e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c8                	add    %ecx,%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f8:	7c d9                	jl     8010d3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
}
  801105:	90                   	nop
  801106:	c9                   	leave  
  801107:	c3                   	ret    

00801108 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110b:	8b 45 14             	mov    0x14(%ebp),%eax
  80110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112b:	eb 0c                	jmp    801139 <strsplit+0x31>
			*string++ = 0;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	84 c0                	test   %al,%al
  801140:	74 18                	je     80115a <strsplit+0x52>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f be c0             	movsbl %al,%eax
  80114a:	50                   	push   %eax
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	e8 13 fb ff ff       	call   800c66 <strchr>
  801153:	83 c4 08             	add    $0x8,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	75 d3                	jne    80112d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	84 c0                	test   %al,%al
  801161:	74 5a                	je     8011bd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801163:	8b 45 14             	mov    0x14(%ebp),%eax
  801166:	8b 00                	mov    (%eax),%eax
  801168:	83 f8 0f             	cmp    $0xf,%eax
  80116b:	75 07                	jne    801174 <strsplit+0x6c>
		{
			return 0;
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
  801172:	eb 66                	jmp    8011da <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	8d 48 01             	lea    0x1(%eax),%ecx
  80117c:	8b 55 14             	mov    0x14(%ebp),%edx
  80117f:	89 0a                	mov    %ecx,(%edx)
  801181:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801192:	eb 03                	jmp    801197 <strsplit+0x8f>
			string++;
  801194:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	84 c0                	test   %al,%al
  80119e:	74 8b                	je     80112b <strsplit+0x23>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	0f be c0             	movsbl %al,%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	e8 b5 fa ff ff       	call   800c66 <strchr>
  8011b1:	83 c4 08             	add    $0x8,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	74 dc                	je     801194 <strsplit+0x8c>
			string++;
	}
  8011b8:	e9 6e ff ff ff       	jmp    80112b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011bd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011be:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 d0                	add    %edx,%eax
  8011cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8011e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e9:	eb 4c                	jmp    801237 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8011eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 40                	cmp    $0x40,%al
  8011f7:	7e 27                	jle    801220 <str2lower+0x44>
  8011f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3c 5a                	cmp    $0x5a,%al
  801205:	7f 19                	jg     801220 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801207:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	01 d0                	add    %edx,%eax
  80120f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801212:	8b 55 0c             	mov    0xc(%ebp),%edx
  801215:	01 ca                	add    %ecx,%edx
  801217:	8a 12                	mov    (%edx),%dl
  801219:	83 c2 20             	add    $0x20,%edx
  80121c:	88 10                	mov    %dl,(%eax)
  80121e:	eb 14                	jmp    801234 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801220:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	01 c2                	add    %eax,%edx
  801228:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	01 c8                	add    %ecx,%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801234:	ff 45 fc             	incl   -0x4(%ebp)
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	e8 95 f8 ff ff       	call   800ad4 <strlen>
  80123f:	83 c4 04             	add    $0x4,%esp
  801242:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801245:	7f a4                	jg     8011eb <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801260:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801263:	8b 7d 18             	mov    0x18(%ebp),%edi
  801266:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801269:	cd 30                	int    $0x30
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80126e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	5b                   	pop    %ebx
  801275:	5e                   	pop    %esi
  801276:	5f                   	pop    %edi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	8b 45 10             	mov    0x10(%ebp),%eax
  801282:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801285:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	52                   	push   %edx
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	50                   	push   %eax
  801295:	6a 00                	push   $0x0
  801297:	e8 b2 ff ff ff       	call   80124e <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 01                	push   $0x1
  8012b1:	e8 98 ff ff ff       	call   80124e <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	52                   	push   %edx
  8012cb:	50                   	push   %eax
  8012cc:	6a 05                	push   $0x5
  8012ce:	e8 7b ff ff ff       	call   80124e <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	51                   	push   %ecx
  8012ef:	52                   	push   %edx
  8012f0:	50                   	push   %eax
  8012f1:	6a 06                	push   $0x6
  8012f3:	e8 56 ff ff ff       	call   80124e <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fe:	5b                   	pop    %ebx
  8012ff:	5e                   	pop    %esi
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801305:	8b 55 0c             	mov    0xc(%ebp),%edx
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	52                   	push   %edx
  801312:	50                   	push   %eax
  801313:	6a 07                	push   $0x7
  801315:	e8 34 ff ff ff       	call   80124e <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	6a 08                	push   $0x8
  801330:	e8 19 ff ff ff       	call   80124e <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 09                	push   $0x9
  801349:	e8 00 ff ff ff       	call   80124e <syscall>
  80134e:	83 c4 18             	add    $0x18,%esp
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 0a                	push   $0xa
  801362:	e8 e7 fe ff ff       	call   80124e <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 0b                	push   $0xb
  80137b:	e8 ce fe ff ff       	call   80124e <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 0c                	push   $0xc
  801394:	e8 b5 fe ff ff       	call   80124e <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	6a 0d                	push   $0xd
  8013ae:	e8 9b fe ff ff       	call   80124e <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 0e                	push   $0xe
  8013c7:	e8 82 fe ff ff       	call   80124e <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	90                   	nop
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 11                	push   $0x11
  8013e1:	e8 68 fe ff ff       	call   80124e <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	90                   	nop
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 12                	push   $0x12
  8013fb:	e8 4e fe ff ff       	call   80124e <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	90                   	nop
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_cputc>:


void
sys_cputc(const char c)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801412:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	50                   	push   %eax
  80141f:	6a 13                	push   $0x13
  801421:	e8 28 fe ff ff       	call   80124e <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	90                   	nop
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 14                	push   $0x14
  80143b:	e8 0e fe ff ff       	call   80124e <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	50                   	push   %eax
  801456:	6a 15                	push   $0x15
  801458:	e8 f1 fd ff ff       	call   80124e <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	52                   	push   %edx
  801472:	50                   	push   %eax
  801473:	6a 18                	push   $0x18
  801475:	e8 d4 fd ff ff       	call   80124e <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	52                   	push   %edx
  80148f:	50                   	push   %eax
  801490:	6a 16                	push   $0x16
  801492:	e8 b7 fd ff ff       	call   80124e <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	52                   	push   %edx
  8014ad:	50                   	push   %eax
  8014ae:	6a 17                	push   $0x17
  8014b0:	e8 99 fd ff ff       	call   80124e <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	90                   	nop
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	51                   	push   %ecx
  8014d4:	52                   	push   %edx
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	50                   	push   %eax
  8014d9:	6a 19                	push   $0x19
  8014db:	e8 6e fd ff ff       	call   80124e <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	52                   	push   %edx
  8014f5:	50                   	push   %eax
  8014f6:	6a 1a                	push   $0x1a
  8014f8:	e8 51 fd ff ff       	call   80124e <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801505:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	51                   	push   %ecx
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	6a 1b                	push   $0x1b
  801517:	e8 32 fd ff ff       	call   80124e <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801524:	8b 55 0c             	mov    0xc(%ebp),%edx
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	52                   	push   %edx
  801531:	50                   	push   %eax
  801532:	6a 1c                	push   $0x1c
  801534:	e8 15 fd ff ff       	call   80124e <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 1d                	push   $0x1d
  80154d:	e8 fc fc ff ff       	call   80124e <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 14             	pushl  0x14(%ebp)
  801562:	ff 75 10             	pushl  0x10(%ebp)
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	50                   	push   %eax
  801569:	6a 1e                	push   $0x1e
  80156b:	e8 de fc ff ff       	call   80124e <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	50                   	push   %eax
  801584:	6a 1f                	push   $0x1f
  801586:	e8 c3 fc ff ff       	call   80124e <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	90                   	nop
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	50                   	push   %eax
  8015a0:	6a 20                	push   $0x20
  8015a2:	e8 a7 fc ff ff       	call   80124e <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 02                	push   $0x2
  8015bb:	e8 8e fc ff ff       	call   80124e <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 03                	push   $0x3
  8015d4:	e8 75 fc ff ff       	call   80124e <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 04                	push   $0x4
  8015ed:	e8 5c fc ff ff       	call   80124e <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_exit_env>:


void sys_exit_env(void)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 21                	push   $0x21
  801606:	e8 43 fc ff ff       	call   80124e <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	90                   	nop
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801617:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161a:	8d 50 04             	lea    0x4(%eax),%edx
  80161d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	52                   	push   %edx
  801627:	50                   	push   %eax
  801628:	6a 22                	push   $0x22
  80162a:	e8 1f fc ff ff       	call   80124e <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
	return result;
  801632:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163b:	89 01                	mov    %eax,(%ecx)
  80163d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	c9                   	leave  
  801644:	c2 04 00             	ret    $0x4

00801647 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	ff 75 10             	pushl  0x10(%ebp)
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	6a 10                	push   $0x10
  801659:	e8 f0 fb ff ff       	call   80124e <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
	return ;
  801661:	90                   	nop
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_rcr2>:
uint32 sys_rcr2()
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 23                	push   $0x23
  801673:	e8 d6 fb ff ff       	call   80124e <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801689:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	50                   	push   %eax
  801696:	6a 24                	push   $0x24
  801698:	e8 b1 fb ff ff       	call   80124e <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a0:	90                   	nop
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <rsttst>:
void rsttst()
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 26                	push   $0x26
  8016b2:	e8 97 fb ff ff       	call   80124e <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ba:	90                   	nop
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016c9:	8b 55 18             	mov    0x18(%ebp),%edx
  8016cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d0:	52                   	push   %edx
  8016d1:	50                   	push   %eax
  8016d2:	ff 75 10             	pushl  0x10(%ebp)
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	ff 75 08             	pushl  0x8(%ebp)
  8016db:	6a 25                	push   $0x25
  8016dd:	e8 6c fb ff ff       	call   80124e <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e5:	90                   	nop
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <chktst>:
void chktst(uint32 n)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	6a 27                	push   $0x27
  8016f8:	e8 51 fb ff ff       	call   80124e <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801700:	90                   	nop
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <inctst>:

void inctst()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 28                	push   $0x28
  801712:	e8 37 fb ff ff       	call   80124e <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
	return ;
  80171a:	90                   	nop
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <gettst>:
uint32 gettst()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 29                	push   $0x29
  80172c:	e8 1d fb ff ff       	call   80124e <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 2a                	push   $0x2a
  801748:	e8 01 fb ff ff       	call   80124e <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801753:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801757:	75 07                	jne    801760 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801759:	b8 01 00 00 00       	mov    $0x1,%eax
  80175e:	eb 05                	jmp    801765 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 2a                	push   $0x2a
  801779:	e8 d0 fa ff ff       	call   80124e <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801784:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801788:	75 07                	jne    801791 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80178a:	b8 01 00 00 00       	mov    $0x1,%eax
  80178f:	eb 05                	jmp    801796 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 2a                	push   $0x2a
  8017aa:	e8 9f fa ff ff       	call   80124e <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
  8017b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017b9:	75 07                	jne    8017c2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c0:	eb 05                	jmp    8017c7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 2a                	push   $0x2a
  8017db:	e8 6e fa ff ff       	call   80124e <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
  8017e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017e6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ea:	75 07                	jne    8017f3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f1:	eb 05                	jmp    8017f8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 2b                	push   $0x2b
  80180a:	e8 3f fa ff ff       	call   80124e <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801819:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	53                   	push   %ebx
  801828:	51                   	push   %ecx
  801829:	52                   	push   %edx
  80182a:	50                   	push   %eax
  80182b:	6a 2c                	push   $0x2c
  80182d:	e8 1c fa ff ff       	call   80124e <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80183d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	6a 2d                	push   $0x2d
  80184d:	e8 fc f9 ff ff       	call   80124e <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80185a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	51                   	push   %ecx
  801866:	ff 75 10             	pushl  0x10(%ebp)
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 2e                	push   $0x2e
  80186d:	e8 dc f9 ff ff       	call   80124e <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	ff 75 10             	pushl  0x10(%ebp)
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 0f                	push   $0xf
  801889:	e8 c0 f9 ff ff       	call   80124e <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	50                   	push   %eax
  8018a3:	6a 2f                	push   $0x2f
  8018a5:	e8 a4 f9 ff ff       	call   80124e <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp

}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	6a 30                	push   $0x30
  8018c0:	e8 89 f9 ff ff       	call   80124e <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
	return;
  8018c8:	90                   	nop
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	6a 31                	push   $0x31
  8018dc:	e8 6d f9 ff ff       	call   80124e <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
	return;
  8018e4:	90                   	nop
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 32                	push   $0x32
  8018f6:	e8 53 f9 ff ff       	call   80124e <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	50                   	push   %eax
  80190f:	6a 33                	push   $0x33
  801911:	e8 38 f9 ff ff       	call   80124e <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <__udivdi3>:
  80191c:	55                   	push   %ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	83 ec 1c             	sub    $0x1c,%esp
  801923:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801927:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80192b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80192f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801933:	89 ca                	mov    %ecx,%edx
  801935:	89 f8                	mov    %edi,%eax
  801937:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80193b:	85 f6                	test   %esi,%esi
  80193d:	75 2d                	jne    80196c <__udivdi3+0x50>
  80193f:	39 cf                	cmp    %ecx,%edi
  801941:	77 65                	ja     8019a8 <__udivdi3+0x8c>
  801943:	89 fd                	mov    %edi,%ebp
  801945:	85 ff                	test   %edi,%edi
  801947:	75 0b                	jne    801954 <__udivdi3+0x38>
  801949:	b8 01 00 00 00       	mov    $0x1,%eax
  80194e:	31 d2                	xor    %edx,%edx
  801950:	f7 f7                	div    %edi
  801952:	89 c5                	mov    %eax,%ebp
  801954:	31 d2                	xor    %edx,%edx
  801956:	89 c8                	mov    %ecx,%eax
  801958:	f7 f5                	div    %ebp
  80195a:	89 c1                	mov    %eax,%ecx
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	f7 f5                	div    %ebp
  801960:	89 cf                	mov    %ecx,%edi
  801962:	89 fa                	mov    %edi,%edx
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
  80196c:	39 ce                	cmp    %ecx,%esi
  80196e:	77 28                	ja     801998 <__udivdi3+0x7c>
  801970:	0f bd fe             	bsr    %esi,%edi
  801973:	83 f7 1f             	xor    $0x1f,%edi
  801976:	75 40                	jne    8019b8 <__udivdi3+0x9c>
  801978:	39 ce                	cmp    %ecx,%esi
  80197a:	72 0a                	jb     801986 <__udivdi3+0x6a>
  80197c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801980:	0f 87 9e 00 00 00    	ja     801a24 <__udivdi3+0x108>
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
  80198b:	89 fa                	mov    %edi,%edx
  80198d:	83 c4 1c             	add    $0x1c,%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5f                   	pop    %edi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    
  801995:	8d 76 00             	lea    0x0(%esi),%esi
  801998:	31 ff                	xor    %edi,%edi
  80199a:	31 c0                	xor    %eax,%eax
  80199c:	89 fa                	mov    %edi,%edx
  80199e:	83 c4 1c             	add    $0x1c,%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5f                   	pop    %edi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    
  8019a6:	66 90                	xchg   %ax,%ax
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	f7 f7                	div    %edi
  8019ac:	31 ff                	xor    %edi,%edi
  8019ae:	89 fa                	mov    %edi,%edx
  8019b0:	83 c4 1c             	add    $0x1c,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5f                   	pop    %edi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    
  8019b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019bd:	89 eb                	mov    %ebp,%ebx
  8019bf:	29 fb                	sub    %edi,%ebx
  8019c1:	89 f9                	mov    %edi,%ecx
  8019c3:	d3 e6                	shl    %cl,%esi
  8019c5:	89 c5                	mov    %eax,%ebp
  8019c7:	88 d9                	mov    %bl,%cl
  8019c9:	d3 ed                	shr    %cl,%ebp
  8019cb:	89 e9                	mov    %ebp,%ecx
  8019cd:	09 f1                	or     %esi,%ecx
  8019cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d3:	89 f9                	mov    %edi,%ecx
  8019d5:	d3 e0                	shl    %cl,%eax
  8019d7:	89 c5                	mov    %eax,%ebp
  8019d9:	89 d6                	mov    %edx,%esi
  8019db:	88 d9                	mov    %bl,%cl
  8019dd:	d3 ee                	shr    %cl,%esi
  8019df:	89 f9                	mov    %edi,%ecx
  8019e1:	d3 e2                	shl    %cl,%edx
  8019e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e7:	88 d9                	mov    %bl,%cl
  8019e9:	d3 e8                	shr    %cl,%eax
  8019eb:	09 c2                	or     %eax,%edx
  8019ed:	89 d0                	mov    %edx,%eax
  8019ef:	89 f2                	mov    %esi,%edx
  8019f1:	f7 74 24 0c          	divl   0xc(%esp)
  8019f5:	89 d6                	mov    %edx,%esi
  8019f7:	89 c3                	mov    %eax,%ebx
  8019f9:	f7 e5                	mul    %ebp
  8019fb:	39 d6                	cmp    %edx,%esi
  8019fd:	72 19                	jb     801a18 <__udivdi3+0xfc>
  8019ff:	74 0b                	je     801a0c <__udivdi3+0xf0>
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	31 ff                	xor    %edi,%edi
  801a05:	e9 58 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a10:	89 f9                	mov    %edi,%ecx
  801a12:	d3 e2                	shl    %cl,%edx
  801a14:	39 c2                	cmp    %eax,%edx
  801a16:	73 e9                	jae    801a01 <__udivdi3+0xe5>
  801a18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a1b:	31 ff                	xor    %edi,%edi
  801a1d:	e9 40 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a22:	66 90                	xchg   %ax,%ax
  801a24:	31 c0                	xor    %eax,%eax
  801a26:	e9 37 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a2b:	90                   	nop

00801a2c <__umoddi3>:
  801a2c:	55                   	push   %ebp
  801a2d:	57                   	push   %edi
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 1c             	sub    $0x1c,%esp
  801a33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a4b:	89 f3                	mov    %esi,%ebx
  801a4d:	89 fa                	mov    %edi,%edx
  801a4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a53:	89 34 24             	mov    %esi,(%esp)
  801a56:	85 c0                	test   %eax,%eax
  801a58:	75 1a                	jne    801a74 <__umoddi3+0x48>
  801a5a:	39 f7                	cmp    %esi,%edi
  801a5c:	0f 86 a2 00 00 00    	jbe    801b04 <__umoddi3+0xd8>
  801a62:	89 c8                	mov    %ecx,%eax
  801a64:	89 f2                	mov    %esi,%edx
  801a66:	f7 f7                	div    %edi
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	31 d2                	xor    %edx,%edx
  801a6c:	83 c4 1c             	add    $0x1c,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5f                   	pop    %edi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
  801a74:	39 f0                	cmp    %esi,%eax
  801a76:	0f 87 ac 00 00 00    	ja     801b28 <__umoddi3+0xfc>
  801a7c:	0f bd e8             	bsr    %eax,%ebp
  801a7f:	83 f5 1f             	xor    $0x1f,%ebp
  801a82:	0f 84 ac 00 00 00    	je     801b34 <__umoddi3+0x108>
  801a88:	bf 20 00 00 00       	mov    $0x20,%edi
  801a8d:	29 ef                	sub    %ebp,%edi
  801a8f:	89 fe                	mov    %edi,%esi
  801a91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a95:	89 e9                	mov    %ebp,%ecx
  801a97:	d3 e0                	shl    %cl,%eax
  801a99:	89 d7                	mov    %edx,%edi
  801a9b:	89 f1                	mov    %esi,%ecx
  801a9d:	d3 ef                	shr    %cl,%edi
  801a9f:	09 c7                	or     %eax,%edi
  801aa1:	89 e9                	mov    %ebp,%ecx
  801aa3:	d3 e2                	shl    %cl,%edx
  801aa5:	89 14 24             	mov    %edx,(%esp)
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	d3 e0                	shl    %cl,%eax
  801aac:	89 c2                	mov    %eax,%edx
  801aae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab2:	d3 e0                	shl    %cl,%eax
  801ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abc:	89 f1                	mov    %esi,%ecx
  801abe:	d3 e8                	shr    %cl,%eax
  801ac0:	09 d0                	or     %edx,%eax
  801ac2:	d3 eb                	shr    %cl,%ebx
  801ac4:	89 da                	mov    %ebx,%edx
  801ac6:	f7 f7                	div    %edi
  801ac8:	89 d3                	mov    %edx,%ebx
  801aca:	f7 24 24             	mull   (%esp)
  801acd:	89 c6                	mov    %eax,%esi
  801acf:	89 d1                	mov    %edx,%ecx
  801ad1:	39 d3                	cmp    %edx,%ebx
  801ad3:	0f 82 87 00 00 00    	jb     801b60 <__umoddi3+0x134>
  801ad9:	0f 84 91 00 00 00    	je     801b70 <__umoddi3+0x144>
  801adf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ae3:	29 f2                	sub    %esi,%edx
  801ae5:	19 cb                	sbb    %ecx,%ebx
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801aed:	d3 e0                	shl    %cl,%eax
  801aef:	89 e9                	mov    %ebp,%ecx
  801af1:	d3 ea                	shr    %cl,%edx
  801af3:	09 d0                	or     %edx,%eax
  801af5:	89 e9                	mov    %ebp,%ecx
  801af7:	d3 eb                	shr    %cl,%ebx
  801af9:	89 da                	mov    %ebx,%edx
  801afb:	83 c4 1c             	add    $0x1c,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5f                   	pop    %edi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
  801b03:	90                   	nop
  801b04:	89 fd                	mov    %edi,%ebp
  801b06:	85 ff                	test   %edi,%edi
  801b08:	75 0b                	jne    801b15 <__umoddi3+0xe9>
  801b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0f:	31 d2                	xor    %edx,%edx
  801b11:	f7 f7                	div    %edi
  801b13:	89 c5                	mov    %eax,%ebp
  801b15:	89 f0                	mov    %esi,%eax
  801b17:	31 d2                	xor    %edx,%edx
  801b19:	f7 f5                	div    %ebp
  801b1b:	89 c8                	mov    %ecx,%eax
  801b1d:	f7 f5                	div    %ebp
  801b1f:	89 d0                	mov    %edx,%eax
  801b21:	e9 44 ff ff ff       	jmp    801a6a <__umoddi3+0x3e>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	89 c8                	mov    %ecx,%eax
  801b2a:	89 f2                	mov    %esi,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	3b 04 24             	cmp    (%esp),%eax
  801b37:	72 06                	jb     801b3f <__umoddi3+0x113>
  801b39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b3d:	77 0f                	ja     801b4e <__umoddi3+0x122>
  801b3f:	89 f2                	mov    %esi,%edx
  801b41:	29 f9                	sub    %edi,%ecx
  801b43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b47:	89 14 24             	mov    %edx,(%esp)
  801b4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b52:	8b 14 24             	mov    (%esp),%edx
  801b55:	83 c4 1c             	add    $0x1c,%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5f                   	pop    %edi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    
  801b5d:	8d 76 00             	lea    0x0(%esi),%esi
  801b60:	2b 04 24             	sub    (%esp),%eax
  801b63:	19 fa                	sbb    %edi,%edx
  801b65:	89 d1                	mov    %edx,%ecx
  801b67:	89 c6                	mov    %eax,%esi
  801b69:	e9 71 ff ff ff       	jmp    801adf <__umoddi3+0xb3>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b74:	72 ea                	jb     801b60 <__umoddi3+0x134>
  801b76:	89 d9                	mov    %ebx,%ecx
  801b78:	e9 62 ff ff ff       	jmp    801adf <__umoddi3+0xb3>
