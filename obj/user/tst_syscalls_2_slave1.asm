
obj/user/tst_syscalls_2_slave1:     file format elf32-i386


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
  800031:	e8 30 00 00 00       	call   800066 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	//[1] NULL (0) address
	sys_allocate_user_mem(0,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	6a 00                	push   $0x0
  800045:	e8 80 18 00 00       	call   8018ca <sys_allocate_user_mem>
  80004a:	83 c4 10             	add    $0x10,%esp
	inctst();
  80004d:	e8 b0 16 00 00       	call   801702 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800052:	83 ec 04             	sub    $0x4,%esp
  800055:	68 80 1b 80 00       	push   $0x801b80
  80005a:	6a 0a                	push   $0xa
  80005c:	68 02 1c 80 00       	push   $0x801c02
  800061:	e8 2e 01 00 00       	call   800194 <_panic>

00800066 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006c:	e8 53 15 00 00       	call   8015c4 <sys_getenvindex>
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800077:	89 d0                	mov    %edx,%eax
  800079:	01 c0                	add    %eax,%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	c1 e0 06             	shl    $0x6,%eax
  800080:	29 d0                	sub    %edx,%eax
  800082:	c1 e0 03             	shl    $0x3,%eax
  800085:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80008f:	a1 20 30 80 00       	mov    0x803020,%eax
  800094:	8a 40 68             	mov    0x68(%eax),%al
  800097:	84 c0                	test   %al,%al
  800099:	74 0d                	je     8000a8 <libmain+0x42>
		binaryname = myEnv->prog_name;
  80009b:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a0:	83 c0 68             	add    $0x68,%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ac:	7e 0a                	jle    8000b8 <libmain+0x52>
		binaryname = argv[0];
  8000ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b1:	8b 00                	mov    (%eax),%eax
  8000b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000b8:	83 ec 08             	sub    $0x8,%esp
  8000bb:	ff 75 0c             	pushl  0xc(%ebp)
  8000be:	ff 75 08             	pushl  0x8(%ebp)
  8000c1:	e8 72 ff ff ff       	call   800038 <_main>
  8000c6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000c9:	e8 03 13 00 00       	call   8013d1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 38 1c 80 00       	push   $0x801c38
  8000d6:	e8 76 03 00 00       	call   800451 <cprintf>
  8000db:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000de:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e3:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ee:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	52                   	push   %edx
  8000f8:	50                   	push   %eax
  8000f9:	68 60 1c 80 00       	push   $0x801c60
  8000fe:	e8 4e 03 00 00       	call   800451 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800106:	a1 20 30 80 00       	mov    0x803020,%eax
  80010b:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800111:	a1 20 30 80 00       	mov    0x803020,%eax
  800116:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80011c:	a1 20 30 80 00       	mov    0x803020,%eax
  800121:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800127:	51                   	push   %ecx
  800128:	52                   	push   %edx
  800129:	50                   	push   %eax
  80012a:	68 88 1c 80 00       	push   $0x801c88
  80012f:	e8 1d 03 00 00       	call   800451 <cprintf>
  800134:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800137:	a1 20 30 80 00       	mov    0x803020,%eax
  80013c:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	50                   	push   %eax
  800146:	68 e0 1c 80 00       	push   $0x801ce0
  80014b:	e8 01 03 00 00       	call   800451 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 38 1c 80 00       	push   $0x801c38
  80015b:	e8 f1 02 00 00       	call   800451 <cprintf>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800163:	e8 83 12 00 00       	call   8013eb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800168:	e8 19 00 00 00       	call   800186 <exit>
}
  80016d:	90                   	nop
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	6a 00                	push   $0x0
  80017b:	e8 10 14 00 00       	call   801590 <sys_destroy_env>
  800180:	83 c4 10             	add    $0x10,%esp
}
  800183:	90                   	nop
  800184:	c9                   	leave  
  800185:	c3                   	ret    

00800186 <exit>:

void
exit(void)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018c:	e8 65 14 00 00       	call   8015f6 <sys_exit_env>
}
  800191:	90                   	nop
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80019a:	8d 45 10             	lea    0x10(%ebp),%eax
  80019d:	83 c0 04             	add    $0x4,%eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001a3:	a1 18 31 80 00       	mov    0x803118,%eax
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	74 16                	je     8001c2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001ac:	a1 18 31 80 00       	mov    0x803118,%eax
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	50                   	push   %eax
  8001b5:	68 f4 1c 80 00       	push   $0x801cf4
  8001ba:	e8 92 02 00 00       	call   800451 <cprintf>
  8001bf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001c2:	a1 00 30 80 00       	mov    0x803000,%eax
  8001c7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ca:	ff 75 08             	pushl  0x8(%ebp)
  8001cd:	50                   	push   %eax
  8001ce:	68 f9 1c 80 00       	push   $0x801cf9
  8001d3:	e8 79 02 00 00       	call   800451 <cprintf>
  8001d8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001db:	8b 45 10             	mov    0x10(%ebp),%eax
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e4:	50                   	push   %eax
  8001e5:	e8 fc 01 00 00       	call   8003e6 <vcprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	6a 00                	push   $0x0
  8001f2:	68 15 1d 80 00       	push   $0x801d15
  8001f7:	e8 ea 01 00 00       	call   8003e6 <vcprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8001ff:	e8 82 ff ff ff       	call   800186 <exit>

	// should not return here
	while (1) ;
  800204:	eb fe                	jmp    800204 <_panic+0x70>

00800206 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80020c:	a1 20 30 80 00       	mov    0x803020,%eax
  800211:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021a:	39 c2                	cmp    %eax,%edx
  80021c:	74 14                	je     800232 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 18 1d 80 00       	push   $0x801d18
  800226:	6a 26                	push   $0x26
  800228:	68 64 1d 80 00       	push   $0x801d64
  80022d:	e8 62 ff ff ff       	call   800194 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800239:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800240:	e9 c5 00 00 00       	jmp    80030a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800248:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	01 d0                	add    %edx,%eax
  800254:	8b 00                	mov    (%eax),%eax
  800256:	85 c0                	test   %eax,%eax
  800258:	75 08                	jne    800262 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80025a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80025d:	e9 a5 00 00 00       	jmp    800307 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800262:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800269:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800270:	eb 69                	jmp    8002db <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80027d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800280:	89 d0                	mov    %edx,%eax
  800282:	01 c0                	add    %eax,%eax
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 03             	shl    $0x3,%eax
  800289:	01 c8                	add    %ecx,%eax
  80028b:	8a 40 04             	mov    0x4(%eax),%al
  80028e:	84 c0                	test   %al,%al
  800290:	75 46                	jne    8002d8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800292:	a1 20 30 80 00       	mov    0x803020,%eax
  800297:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80029d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a0:	89 d0                	mov    %edx,%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	01 d0                	add    %edx,%eax
  8002a6:	c1 e0 03             	shl    $0x3,%eax
  8002a9:	01 c8                	add    %ecx,%eax
  8002ab:	8b 00                	mov    (%eax),%eax
  8002ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002b8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002bd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	01 c8                	add    %ecx,%eax
  8002c9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002cb:	39 c2                	cmp    %eax,%edx
  8002cd:	75 09                	jne    8002d8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002cf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002d6:	eb 15                	jmp    8002ed <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002d8:	ff 45 e8             	incl   -0x18(%ebp)
  8002db:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e0:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8002e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002e9:	39 c2                	cmp    %eax,%edx
  8002eb:	77 85                	ja     800272 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002f1:	75 14                	jne    800307 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 70 1d 80 00       	push   $0x801d70
  8002fb:	6a 3a                	push   $0x3a
  8002fd:	68 64 1d 80 00       	push   $0x801d64
  800302:	e8 8d fe ff ff       	call   800194 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800307:	ff 45 f0             	incl   -0x10(%ebp)
  80030a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800310:	0f 8c 2f ff ff ff    	jl     800245 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800316:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800324:	eb 26                	jmp    80034c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800326:	a1 20 30 80 00       	mov    0x803020,%eax
  80032b:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800331:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800334:	89 d0                	mov    %edx,%eax
  800336:	01 c0                	add    %eax,%eax
  800338:	01 d0                	add    %edx,%eax
  80033a:	c1 e0 03             	shl    $0x3,%eax
  80033d:	01 c8                	add    %ecx,%eax
  80033f:	8a 40 04             	mov    0x4(%eax),%al
  800342:	3c 01                	cmp    $0x1,%al
  800344:	75 03                	jne    800349 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800346:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	ff 45 e0             	incl   -0x20(%ebp)
  80034c:	a1 20 30 80 00       	mov    0x803020,%eax
  800351:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035a:	39 c2                	cmp    %eax,%edx
  80035c:	77 c8                	ja     800326 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800361:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800364:	74 14                	je     80037a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800366:	83 ec 04             	sub    $0x4,%esp
  800369:	68 c4 1d 80 00       	push   $0x801dc4
  80036e:	6a 44                	push   $0x44
  800370:	68 64 1d 80 00       	push   $0x801d64
  800375:	e8 1a fe ff ff       	call   800194 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80037a:	90                   	nop
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	8b 00                	mov    (%eax),%eax
  800388:	8d 48 01             	lea    0x1(%eax),%ecx
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 0a                	mov    %ecx,(%edx)
  800390:	8b 55 08             	mov    0x8(%ebp),%edx
  800393:	88 d1                	mov    %dl,%cl
  800395:	8b 55 0c             	mov    0xc(%ebp),%edx
  800398:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a6:	75 2c                	jne    8003d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003a8:	a0 24 30 80 00       	mov    0x803024,%al
  8003ad:	0f b6 c0             	movzbl %al,%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	8b 12                	mov    (%edx),%edx
  8003b5:	89 d1                	mov    %edx,%ecx
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	83 c2 08             	add    $0x8,%edx
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	50                   	push   %eax
  8003c1:	51                   	push   %ecx
  8003c2:	52                   	push   %edx
  8003c3:	e8 b0 0e 00 00       	call   801278 <sys_cputs>
  8003c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	8b 40 04             	mov    0x4(%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f6:	00 00 00 
	b.cnt = 0;
  8003f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800400:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800403:	ff 75 0c             	pushl  0xc(%ebp)
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040f:	50                   	push   %eax
  800410:	68 7d 03 80 00       	push   $0x80037d
  800415:	e8 11 02 00 00       	call   80062b <vprintfmt>
  80041a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80041d:	a0 24 30 80 00       	mov    0x803024,%al
  800422:	0f b6 c0             	movzbl %al,%eax
  800425:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	50                   	push   %eax
  80042f:	52                   	push   %edx
  800430:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800436:	83 c0 08             	add    $0x8,%eax
  800439:	50                   	push   %eax
  80043a:	e8 39 0e 00 00       	call   801278 <sys_cputs>
  80043f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800442:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800449:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <cprintf>:

int cprintf(const char *fmt, ...) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800457:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80045e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800461:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	ff 75 f4             	pushl  -0xc(%ebp)
  80046d:	50                   	push   %eax
  80046e:	e8 73 ff ff ff       	call   8003e6 <vcprintf>
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800479:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    

0080047e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80047e:	55                   	push   %ebp
  80047f:	89 e5                	mov    %esp,%ebp
  800481:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800484:	e8 48 0f 00 00       	call   8013d1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800489:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	ff 75 f4             	pushl  -0xc(%ebp)
  800498:	50                   	push   %eax
  800499:	e8 48 ff ff ff       	call   8003e6 <vcprintf>
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004a4:	e8 42 0f 00 00       	call   8013eb <sys_enable_interrupt>
	return cnt;
  8004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	53                   	push   %ebx
  8004b2:	83 ec 14             	sub    $0x14,%esp
  8004b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cc:	77 55                	ja     800523 <printnum+0x75>
  8004ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d1:	72 05                	jb     8004d8 <printnum+0x2a>
  8004d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d6:	77 4b                	ja     800523 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004de:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e6:	52                   	push   %edx
  8004e7:	50                   	push   %eax
  8004e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8004ee:	e8 29 14 00 00       	call   80191c <__udivdi3>
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	ff 75 20             	pushl  0x20(%ebp)
  8004fc:	53                   	push   %ebx
  8004fd:	ff 75 18             	pushl  0x18(%ebp)
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	ff 75 0c             	pushl  0xc(%ebp)
  800505:	ff 75 08             	pushl  0x8(%ebp)
  800508:	e8 a1 ff ff ff       	call   8004ae <printnum>
  80050d:	83 c4 20             	add    $0x20,%esp
  800510:	eb 1a                	jmp    80052c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 20             	pushl  0x20(%ebp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	ff d0                	call   *%eax
  800520:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800523:	ff 4d 1c             	decl   0x1c(%ebp)
  800526:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052a:	7f e6                	jg     800512 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053a:	53                   	push   %ebx
  80053b:	51                   	push   %ecx
  80053c:	52                   	push   %edx
  80053d:	50                   	push   %eax
  80053e:	e8 e9 14 00 00       	call   801a2c <__umoddi3>
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	05 34 20 80 00       	add    $0x802034,%eax
  80054b:	8a 00                	mov    (%eax),%al
  80054d:	0f be c0             	movsbl %al,%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 0c             	pushl  0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	ff d0                	call   *%eax
  80055c:	83 c4 10             	add    $0x10,%esp
}
  80055f:	90                   	nop
  800560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800568:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80056c:	7e 1c                	jle    80058a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	8d 50 08             	lea    0x8(%eax),%edx
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	89 10                	mov    %edx,(%eax)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 e8 08             	sub    $0x8,%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	eb 40                	jmp    8005ca <getuint+0x65>
	else if (lflag)
  80058a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80058e:	74 1e                	je     8005ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	8d 50 04             	lea    0x4(%eax),%edx
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	89 10                	mov    %edx,(%eax)
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	83 e8 04             	sub    $0x4,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ac:	eb 1c                	jmp    8005ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	8d 50 04             	lea    0x4(%eax),%edx
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	89 10                	mov    %edx,(%eax)
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	83 e8 04             	sub    $0x4,%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d3:	7e 1c                	jle    8005f1 <getint+0x25>
		return va_arg(*ap, long long);
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	8d 50 08             	lea    0x8(%eax),%edx
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	89 10                	mov    %edx,(%eax)
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	83 e8 08             	sub    $0x8,%eax
  8005ea:	8b 50 04             	mov    0x4(%eax),%edx
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	eb 38                	jmp    800629 <getint+0x5d>
	else if (lflag)
  8005f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f5:	74 1a                	je     800611 <getint+0x45>
		return va_arg(*ap, long);
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	8d 50 04             	lea    0x4(%eax),%edx
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	89 10                	mov    %edx,(%eax)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	83 e8 04             	sub    $0x4,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	99                   	cltd   
  80060f:	eb 18                	jmp    800629 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 50 04             	lea    0x4(%eax),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 10                	mov    %edx,(%eax)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	99                   	cltd   
}
  800629:	5d                   	pop    %ebp
  80062a:	c3                   	ret    

0080062b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	56                   	push   %esi
  80062f:	53                   	push   %ebx
  800630:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800633:	eb 17                	jmp    80064c <vprintfmt+0x21>
			if (ch == '\0')
  800635:	85 db                	test   %ebx,%ebx
  800637:	0f 84 af 03 00 00    	je     8009ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	53                   	push   %ebx
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064c:	8b 45 10             	mov    0x10(%ebp),%eax
  80064f:	8d 50 01             	lea    0x1(%eax),%edx
  800652:	89 55 10             	mov    %edx,0x10(%ebp)
  800655:	8a 00                	mov    (%eax),%al
  800657:	0f b6 d8             	movzbl %al,%ebx
  80065a:	83 fb 25             	cmp    $0x25,%ebx
  80065d:	75 d6                	jne    800635 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800663:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80066a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800671:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800678:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067f:	8b 45 10             	mov    0x10(%ebp),%eax
  800682:	8d 50 01             	lea    0x1(%eax),%edx
  800685:	89 55 10             	mov    %edx,0x10(%ebp)
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f b6 d8             	movzbl %al,%ebx
  80068d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800690:	83 f8 55             	cmp    $0x55,%eax
  800693:	0f 87 2b 03 00 00    	ja     8009c4 <vprintfmt+0x399>
  800699:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a6:	eb d7                	jmp    80067f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006ac:	eb d1                	jmp    80067f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	c1 e0 02             	shl    $0x2,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	01 d8                	add    %ebx,%eax
  8006c3:	83 e8 30             	sub    $0x30,%eax
  8006c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cc:	8a 00                	mov    (%eax),%al
  8006ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d4:	7e 3e                	jle    800714 <vprintfmt+0xe9>
  8006d6:	83 fb 39             	cmp    $0x39,%ebx
  8006d9:	7f 39                	jg     800714 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006de:	eb d5                	jmp    8006b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	83 c0 04             	add    $0x4,%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 e8 04             	sub    $0x4,%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f4:	eb 1f                	jmp    800715 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fa:	79 83                	jns    80067f <vprintfmt+0x54>
				width = 0;
  8006fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800703:	e9 77 ff ff ff       	jmp    80067f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800708:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070f:	e9 6b ff ff ff       	jmp    80067f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800714:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800715:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800719:	0f 89 60 ff ff ff    	jns    80067f <vprintfmt+0x54>
				width = precision, precision = -1;
  80071f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800725:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80072c:	e9 4e ff ff ff       	jmp    80067f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800731:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800734:	e9 46 ff ff ff       	jmp    80067f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	83 c0 04             	add    $0x4,%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 e8 04             	sub    $0x4,%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	50                   	push   %eax
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
			break;
  800759:	e9 89 02 00 00       	jmp    8009e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	83 c0 04             	add    $0x4,%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076f:	85 db                	test   %ebx,%ebx
  800771:	79 02                	jns    800775 <vprintfmt+0x14a>
				err = -err;
  800773:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800775:	83 fb 64             	cmp    $0x64,%ebx
  800778:	7f 0b                	jg     800785 <vprintfmt+0x15a>
  80077a:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800781:	85 f6                	test   %esi,%esi
  800783:	75 19                	jne    80079e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800785:	53                   	push   %ebx
  800786:	68 45 20 80 00       	push   $0x802045
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	ff 75 08             	pushl  0x8(%ebp)
  800791:	e8 5e 02 00 00       	call   8009f4 <printfmt>
  800796:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800799:	e9 49 02 00 00       	jmp    8009e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80079e:	56                   	push   %esi
  80079f:	68 4e 20 80 00       	push   $0x80204e
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	e8 45 02 00 00       	call   8009f4 <printfmt>
  8007af:	83 c4 10             	add    $0x10,%esp
			break;
  8007b2:	e9 30 02 00 00       	jmp    8009e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	83 c0 04             	add    $0x4,%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 e8 04             	sub    $0x4,%eax
  8007c6:	8b 30                	mov    (%eax),%esi
  8007c8:	85 f6                	test   %esi,%esi
  8007ca:	75 05                	jne    8007d1 <vprintfmt+0x1a6>
				p = "(null)";
  8007cc:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d5:	7e 6d                	jle    800844 <vprintfmt+0x219>
  8007d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007db:	74 67                	je     800844 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	50                   	push   %eax
  8007e4:	56                   	push   %esi
  8007e5:	e8 0c 03 00 00       	call   800af6 <strnlen>
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f0:	eb 16                	jmp    800808 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	50                   	push   %eax
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	ff d0                	call   *%eax
  800802:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800805:	ff 4d e4             	decl   -0x1c(%ebp)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	7f e4                	jg     8007f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080e:	eb 34                	jmp    800844 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800810:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800814:	74 1c                	je     800832 <vprintfmt+0x207>
  800816:	83 fb 1f             	cmp    $0x1f,%ebx
  800819:	7e 05                	jle    800820 <vprintfmt+0x1f5>
  80081b:	83 fb 7e             	cmp    $0x7e,%ebx
  80081e:	7e 12                	jle    800832 <vprintfmt+0x207>
					putch('?', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 3f                	push   $0x3f
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	eb 0f                	jmp    800841 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	53                   	push   %ebx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800841:	ff 4d e4             	decl   -0x1c(%ebp)
  800844:	89 f0                	mov    %esi,%eax
  800846:	8d 70 01             	lea    0x1(%eax),%esi
  800849:	8a 00                	mov    (%eax),%al
  80084b:	0f be d8             	movsbl %al,%ebx
  80084e:	85 db                	test   %ebx,%ebx
  800850:	74 24                	je     800876 <vprintfmt+0x24b>
  800852:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800856:	78 b8                	js     800810 <vprintfmt+0x1e5>
  800858:	ff 4d e0             	decl   -0x20(%ebp)
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	79 af                	jns    800810 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800861:	eb 13                	jmp    800876 <vprintfmt+0x24b>
				putch(' ', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 20                	push   $0x20
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800873:	ff 4d e4             	decl   -0x1c(%ebp)
  800876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087a:	7f e7                	jg     800863 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80087c:	e9 66 01 00 00       	jmp    8009e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 e8             	pushl  -0x18(%ebp)
  800887:	8d 45 14             	lea    0x14(%ebp),%eax
  80088a:	50                   	push   %eax
  80088b:	e8 3c fd ff ff       	call   8005cc <getint>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800896:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	79 23                	jns    8008c6 <vprintfmt+0x29b>
				putch('-', putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	6a 2d                	push   $0x2d
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b9:	f7 d8                	neg    %eax
  8008bb:	83 d2 00             	adc    $0x0,%edx
  8008be:	f7 da                	neg    %edx
  8008c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008cd:	e9 bc 00 00 00       	jmp    80098e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008db:	50                   	push   %eax
  8008dc:	e8 84 fc ff ff       	call   800565 <getuint>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f1:	e9 98 00 00 00       	jmp    80098e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	6a 58                	push   $0x58
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	ff d0                	call   *%eax
  800903:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 58                	push   $0x58
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	6a 58                	push   $0x58
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 bc 00 00 00       	jmp    8009e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	6a 30                	push   $0x30
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	6a 78                	push   $0x78
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 e8 04             	sub    $0x4,%eax
  80095a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800966:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80096d:	eb 1f                	jmp    80098e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 e8             	pushl  -0x18(%ebp)
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	50                   	push   %eax
  800979:	e8 e7 fb ff ff       	call   800565 <getuint>
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800984:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800987:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80098e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800995:	83 ec 04             	sub    $0x4,%esp
  800998:	52                   	push   %edx
  800999:	ff 75 e4             	pushl  -0x1c(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	ff 75 08             	pushl  0x8(%ebp)
  8009a9:	e8 00 fb ff ff       	call   8004ae <printnum>
  8009ae:	83 c4 20             	add    $0x20,%esp
			break;
  8009b1:	eb 34                	jmp    8009e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 0c             	pushl  0xc(%ebp)
  8009b9:	53                   	push   %ebx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			break;
  8009c2:	eb 23                	jmp    8009e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 25                	push   $0x25
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d4:	ff 4d 10             	decl   0x10(%ebp)
  8009d7:	eb 03                	jmp    8009dc <vprintfmt+0x3b1>
  8009d9:	ff 4d 10             	decl   0x10(%ebp)
  8009dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009df:	48                   	dec    %eax
  8009e0:	8a 00                	mov    (%eax),%al
  8009e2:	3c 25                	cmp    $0x25,%al
  8009e4:	75 f3                	jne    8009d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009e6:	90                   	nop
		}
	}
  8009e7:	e9 47 fc ff ff       	jmp    800633 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f0:	5b                   	pop    %ebx
  8009f1:	5e                   	pop    %esi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a03:	8b 45 10             	mov    0x10(%ebp),%eax
  800a06:	ff 75 f4             	pushl  -0xc(%ebp)
  800a09:	50                   	push   %eax
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	ff 75 08             	pushl  0x8(%ebp)
  800a10:	e8 16 fc ff ff       	call   80062b <vprintfmt>
  800a15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a18:	90                   	nop
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	8b 40 08             	mov    0x8(%eax),%eax
  800a24:	8d 50 01             	lea    0x1(%eax),%edx
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8b 10                	mov    (%eax),%edx
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	8b 40 04             	mov    0x4(%eax),%eax
  800a38:	39 c2                	cmp    %eax,%edx
  800a3a:	73 12                	jae    800a4e <sprintputch+0x33>
		*b->buf++ = ch;
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8b 00                	mov    (%eax),%eax
  800a41:	8d 48 01             	lea    0x1(%eax),%ecx
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a47:	89 0a                	mov    %ecx,(%edx)
  800a49:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4c:	88 10                	mov    %dl,(%eax)
}
  800a4e:	90                   	nop
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	01 d0                	add    %edx,%eax
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a76:	74 06                	je     800a7e <vsnprintf+0x2d>
  800a78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7c:	7f 07                	jg     800a85 <vsnprintf+0x34>
		return -E_INVAL;
  800a7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800a83:	eb 20                	jmp    800aa5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a85:	ff 75 14             	pushl  0x14(%ebp)
  800a88:	ff 75 10             	pushl  0x10(%ebp)
  800a8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a8e:	50                   	push   %eax
  800a8f:	68 1b 0a 80 00       	push   $0x800a1b
  800a94:	e8 92 fb ff ff       	call   80062b <vprintfmt>
  800a99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aad:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab0:	83 c0 04             	add    $0x4,%eax
  800ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	ff 75 f4             	pushl  -0xc(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	ff 75 08             	pushl  0x8(%ebp)
  800ac3:	e8 89 ff ff ff       	call   800a51 <vsnprintf>
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae0:	eb 06                	jmp    800ae8 <strlen+0x15>
		n++;
  800ae2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae5:	ff 45 08             	incl   0x8(%ebp)
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	84 c0                	test   %al,%al
  800aef:	75 f1                	jne    800ae2 <strlen+0xf>
		n++;
	return n;
  800af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b03:	eb 09                	jmp    800b0e <strnlen+0x18>
		n++;
  800b05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b08:	ff 45 08             	incl   0x8(%ebp)
  800b0b:	ff 4d 0c             	decl   0xc(%ebp)
  800b0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b12:	74 09                	je     800b1d <strnlen+0x27>
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 e8                	jne    800b05 <strnlen+0xf>
		n++;
	return n;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b2e:	90                   	nop
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8d 50 01             	lea    0x1(%eax),%edx
  800b35:	89 55 08             	mov    %edx,0x8(%ebp)
  800b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b41:	8a 12                	mov    (%edx),%dl
  800b43:	88 10                	mov    %dl,(%eax)
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	84 c0                	test   %al,%al
  800b49:	75 e4                	jne    800b2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b63:	eb 1f                	jmp    800b84 <strncpy+0x34>
		*dst++ = *src;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8d 50 01             	lea    0x1(%eax),%edx
  800b6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	8a 12                	mov    (%edx),%dl
  800b73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	84 c0                	test   %al,%al
  800b7c:	74 03                	je     800b81 <strncpy+0x31>
			src++;
  800b7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b81:	ff 45 fc             	incl   -0x4(%ebp)
  800b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b8a:	72 d9                	jb     800b65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba1:	74 30                	je     800bd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba3:	eb 16                	jmp    800bbb <strlcpy+0x2a>
			*dst++ = *src++;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8d 50 01             	lea    0x1(%eax),%edx
  800bab:	89 55 08             	mov    %edx,0x8(%ebp)
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bb7:	8a 12                	mov    (%edx),%dl
  800bb9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bbb:	ff 4d 10             	decl   0x10(%ebp)
  800bbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc2:	74 09                	je     800bcd <strlcpy+0x3c>
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	84 c0                	test   %al,%al
  800bcb:	75 d8                	jne    800ba5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd9:	29 c2                	sub    %eax,%edx
  800bdb:	89 d0                	mov    %edx,%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be2:	eb 06                	jmp    800bea <strcmp+0xb>
		p++, q++;
  800be4:	ff 45 08             	incl   0x8(%ebp)
  800be7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	84 c0                	test   %al,%al
  800bf1:	74 0e                	je     800c01 <strcmp+0x22>
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 10                	mov    (%eax),%dl
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	38 c2                	cmp    %al,%dl
  800bff:	74 e3                	je     800be4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	0f b6 d0             	movzbl %al,%edx
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	0f b6 c0             	movzbl %al,%eax
  800c11:	29 c2                	sub    %eax,%edx
  800c13:	89 d0                	mov    %edx,%eax
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c1a:	eb 09                	jmp    800c25 <strncmp+0xe>
		n--, p++, q++;
  800c1c:	ff 4d 10             	decl   0x10(%ebp)
  800c1f:	ff 45 08             	incl   0x8(%ebp)
  800c22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c29:	74 17                	je     800c42 <strncmp+0x2b>
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	84 c0                	test   %al,%al
  800c32:	74 0e                	je     800c42 <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 10                	mov    (%eax),%dl
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	38 c2                	cmp    %al,%dl
  800c40:	74 da                	je     800c1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c46:	75 07                	jne    800c4f <strncmp+0x38>
		return 0;
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	eb 14                	jmp    800c63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	0f b6 d0             	movzbl %al,%edx
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	0f b6 c0             	movzbl %al,%eax
  800c5f:	29 c2                	sub    %eax,%edx
  800c61:	89 d0                	mov    %edx,%eax
}
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 04             	sub    $0x4,%esp
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c71:	eb 12                	jmp    800c85 <strchr+0x20>
		if (*s == c)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7b:	75 05                	jne    800c82 <strchr+0x1d>
			return (char *) s;
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	eb 11                	jmp    800c93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c82:	ff 45 08             	incl   0x8(%ebp)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	84 c0                	test   %al,%al
  800c8c:	75 e5                	jne    800c73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca1:	eb 0d                	jmp    800cb0 <strfind+0x1b>
		if (*s == c)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cab:	74 0e                	je     800cbb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 ea                	jne    800ca3 <strfind+0xe>
  800cb9:	eb 01                	jmp    800cbc <strfind+0x27>
		if (*s == c)
			break;
  800cbb:	90                   	nop
	return (char *) s;
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd3:	eb 0e                	jmp    800ce3 <memset+0x22>
		*p++ = c;
  800cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd8:	8d 50 01             	lea    0x1(%eax),%edx
  800cdb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce3:	ff 4d f8             	decl   -0x8(%ebp)
  800ce6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cea:	79 e9                	jns    800cd5 <memset+0x14>
		*p++ = c;

	return v;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d03:	eb 16                	jmp    800d1b <memcpy+0x2a>
		*d++ = *s++;
  800d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d08:	8d 50 01             	lea    0x1(%eax),%edx
  800d0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d17:	8a 12                	mov    (%edx),%dl
  800d19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d21:	89 55 10             	mov    %edx,0x10(%ebp)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	75 dd                	jne    800d05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d45:	73 50                	jae    800d97 <memmove+0x6a>
  800d47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d52:	76 43                	jbe    800d97 <memmove+0x6a>
		s += n;
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d60:	eb 10                	jmp    800d72 <memmove+0x45>
			*--d = *--s;
  800d62:	ff 4d f8             	decl   -0x8(%ebp)
  800d65:	ff 4d fc             	decl   -0x4(%ebp)
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d78:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	75 e3                	jne    800d62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7f:	eb 23                	jmp    800da4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d93:	8a 12                	mov    (%edx),%dl
  800d95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	75 dd                	jne    800d81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dbb:	eb 2a                	jmp    800de7 <memcmp+0x3e>
		if (*s1 != *s2)
  800dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 16                	je     800de1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	0f b6 d0             	movzbl %al,%edx
  800dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	0f b6 c0             	movzbl %al,%eax
  800ddb:	29 c2                	sub    %eax,%edx
  800ddd:	89 d0                	mov    %edx,%eax
  800ddf:	eb 18                	jmp    800df9 <memcmp+0x50>
		s1++, s2++;
  800de1:	ff 45 fc             	incl   -0x4(%ebp)
  800de4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ded:	89 55 10             	mov    %edx,0x10(%ebp)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	75 c9                	jne    800dbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	01 d0                	add    %edx,%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e0c:	eb 15                	jmp    800e23 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	0f b6 d0             	movzbl %al,%edx
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	0f b6 c0             	movzbl %al,%eax
  800e1c:	39 c2                	cmp    %eax,%edx
  800e1e:	74 0d                	je     800e2d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e20:	ff 45 08             	incl   0x8(%ebp)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e29:	72 e3                	jb     800e0e <memfind+0x13>
  800e2b:	eb 01                	jmp    800e2e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e2d:	90                   	nop
	return (void *) s;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e47:	eb 03                	jmp    800e4c <strtol+0x19>
		s++;
  800e49:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	3c 20                	cmp    $0x20,%al
  800e53:	74 f4                	je     800e49 <strtol+0x16>
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 09                	cmp    $0x9,%al
  800e5c:	74 eb                	je     800e49 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 2b                	cmp    $0x2b,%al
  800e65:	75 05                	jne    800e6c <strtol+0x39>
		s++;
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	eb 13                	jmp    800e7f <strtol+0x4c>
	else if (*s == '-')
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 2d                	cmp    $0x2d,%al
  800e73:	75 0a                	jne    800e7f <strtol+0x4c>
		s++, neg = 1;
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e83:	74 06                	je     800e8b <strtol+0x58>
  800e85:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e89:	75 20                	jne    800eab <strtol+0x78>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	3c 30                	cmp    $0x30,%al
  800e92:	75 17                	jne    800eab <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	40                   	inc    %eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	3c 78                	cmp    $0x78,%al
  800e9c:	75 0d                	jne    800eab <strtol+0x78>
		s += 2, base = 16;
  800e9e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ea9:	eb 28                	jmp    800ed3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	75 15                	jne    800ec6 <strtol+0x93>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3c 30                	cmp    $0x30,%al
  800eb8:	75 0c                	jne    800ec6 <strtol+0x93>
		s++, base = 8;
  800eba:	ff 45 08             	incl   0x8(%ebp)
  800ebd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec4:	eb 0d                	jmp    800ed3 <strtol+0xa0>
	else if (base == 0)
  800ec6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eca:	75 07                	jne    800ed3 <strtol+0xa0>
		base = 10;
  800ecc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	3c 2f                	cmp    $0x2f,%al
  800eda:	7e 19                	jle    800ef5 <strtol+0xc2>
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 39                	cmp    $0x39,%al
  800ee3:	7f 10                	jg     800ef5 <strtol+0xc2>
			dig = *s - '0';
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	0f be c0             	movsbl %al,%eax
  800eed:	83 e8 30             	sub    $0x30,%eax
  800ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef3:	eb 42                	jmp    800f37 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	3c 60                	cmp    $0x60,%al
  800efc:	7e 19                	jle    800f17 <strtol+0xe4>
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 7a                	cmp    $0x7a,%al
  800f05:	7f 10                	jg     800f17 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f be c0             	movsbl %al,%eax
  800f0f:	83 e8 57             	sub    $0x57,%eax
  800f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f15:	eb 20                	jmp    800f37 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3c 40                	cmp    $0x40,%al
  800f1e:	7e 39                	jle    800f59 <strtol+0x126>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 5a                	cmp    $0x5a,%al
  800f27:	7f 30                	jg     800f59 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f be c0             	movsbl %al,%eax
  800f31:	83 e8 37             	sub    $0x37,%eax
  800f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f3d:	7d 19                	jge    800f58 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f49:	89 c2                	mov    %eax,%edx
  800f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4e:	01 d0                	add    %edx,%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f53:	e9 7b ff ff ff       	jmp    800ed3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f58:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5d:	74 08                	je     800f67 <strtol+0x134>
		*endptr = (char *) s;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f6b:	74 07                	je     800f74 <strtol+0x141>
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	f7 d8                	neg    %eax
  800f72:	eb 03                	jmp    800f77 <strtol+0x144>
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <ltostr>:

void
ltostr(long value, char *str)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f86:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f91:	79 13                	jns    800fa6 <ltostr+0x2d>
	{
		neg = 1;
  800f93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fae:	99                   	cltd   
  800faf:	f7 f9                	idiv   %ecx
  800fb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8d 50 01             	lea    0x1(%eax),%edx
  800fba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc7:	83 c2 30             	add    $0x30,%edx
  800fca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fcf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd4:	f7 e9                	imul   %ecx
  800fd6:	c1 fa 02             	sar    $0x2,%edx
  800fd9:	89 c8                	mov    %ecx,%eax
  800fdb:	c1 f8 1f             	sar    $0x1f,%eax
  800fde:	29 c2                	sub    %eax,%edx
  800fe0:	89 d0                	mov    %edx,%eax
  800fe2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fe5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fed:	f7 e9                	imul   %ecx
  800fef:	c1 fa 02             	sar    $0x2,%edx
  800ff2:	89 c8                	mov    %ecx,%eax
  800ff4:	c1 f8 1f             	sar    $0x1f,%eax
  800ff7:	29 c2                	sub    %eax,%edx
  800ff9:	89 d0                	mov    %edx,%eax
  800ffb:	c1 e0 02             	shl    $0x2,%eax
  800ffe:	01 d0                	add    %edx,%eax
  801000:	01 c0                	add    %eax,%eax
  801002:	29 c1                	sub    %eax,%ecx
  801004:	89 ca                	mov    %ecx,%edx
  801006:	85 d2                	test   %edx,%edx
  801008:	75 9c                	jne    800fa6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	48                   	dec    %eax
  801015:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801018:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101c:	74 3d                	je     80105b <ltostr+0xe2>
		start = 1 ;
  80101e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801025:	eb 34                	jmp    80105b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	01 d0                	add    %edx,%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	01 c2                	add    %eax,%edx
  80103c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	01 c8                	add    %ecx,%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801048:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	01 c2                	add    %eax,%edx
  801050:	8a 45 eb             	mov    -0x15(%ebp),%al
  801053:	88 02                	mov    %al,(%edx)
		start++ ;
  801055:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801058:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	7c c4                	jl     801027 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801063:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	01 d0                	add    %edx,%eax
  80106b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106e:	90                   	nop
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801077:	ff 75 08             	pushl  0x8(%ebp)
  80107a:	e8 54 fa ff ff       	call   800ad3 <strlen>
  80107f:	83 c4 04             	add    $0x4,%esp
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801085:	ff 75 0c             	pushl  0xc(%ebp)
  801088:	e8 46 fa ff ff       	call   800ad3 <strlen>
  80108d:	83 c4 04             	add    $0x4,%esp
  801090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801093:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a1:	eb 17                	jmp    8010ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	01 c2                	add    %eax,%edx
  8010ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	01 c8                	add    %ecx,%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b7:	ff 45 fc             	incl   -0x4(%ebp)
  8010ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c0:	7c e1                	jl     8010a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d0:	eb 1f                	jmp    8010f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d5:	8d 50 01             	lea    0x1(%eax),%edx
  8010d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010db:	89 c2                	mov    %eax,%edx
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	01 c2                	add    %eax,%edx
  8010e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	01 c8                	add    %ecx,%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f7:	7c d9                	jl     8010d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	c6 00 00             	movb   $0x0,(%eax)
}
  801104:	90                   	nop
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110a:	8b 45 14             	mov    0x14(%ebp),%eax
  80110d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	8b 00                	mov    (%eax),%eax
  801118:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	01 d0                	add    %edx,%eax
  801124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112a:	eb 0c                	jmp    801138 <strsplit+0x31>
			*string++ = 0;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 08             	mov    %edx,0x8(%ebp)
  801135:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	84 c0                	test   %al,%al
  80113f:	74 18                	je     801159 <strsplit+0x52>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	0f be c0             	movsbl %al,%eax
  801149:	50                   	push   %eax
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	e8 13 fb ff ff       	call   800c65 <strchr>
  801152:	83 c4 08             	add    $0x8,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	75 d3                	jne    80112c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	84 c0                	test   %al,%al
  801160:	74 5a                	je     8011bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801162:	8b 45 14             	mov    0x14(%ebp),%eax
  801165:	8b 00                	mov    (%eax),%eax
  801167:	83 f8 0f             	cmp    $0xf,%eax
  80116a:	75 07                	jne    801173 <strsplit+0x6c>
		{
			return 0;
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
  801171:	eb 66                	jmp    8011d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801173:	8b 45 14             	mov    0x14(%ebp),%eax
  801176:	8b 00                	mov    (%eax),%eax
  801178:	8d 48 01             	lea    0x1(%eax),%ecx
  80117b:	8b 55 14             	mov    0x14(%ebp),%edx
  80117e:	89 0a                	mov    %ecx,(%edx)
  801180:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 c2                	add    %eax,%edx
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801191:	eb 03                	jmp    801196 <strsplit+0x8f>
			string++;
  801193:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	74 8b                	je     80112a <strsplit+0x23>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	50                   	push   %eax
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	e8 b5 fa ff ff       	call   800c65 <strchr>
  8011b0:	83 c4 08             	add    $0x8,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	74 dc                	je     801193 <strsplit+0x8c>
			string++;
	}
  8011b7:	e9 6e ff ff ff       	jmp    80112a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c0:	8b 00                	mov    (%eax),%eax
  8011c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	01 d0                	add    %edx,%eax
  8011ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8011e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e8:	eb 4c                	jmp    801236 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8011ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	3c 40                	cmp    $0x40,%al
  8011f6:	7e 27                	jle    80121f <str2lower+0x44>
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 5a                	cmp    $0x5a,%al
  801204:	7f 19                	jg     80121f <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801211:	8b 55 0c             	mov    0xc(%ebp),%edx
  801214:	01 ca                	add    %ecx,%edx
  801216:	8a 12                	mov    (%edx),%dl
  801218:	83 c2 20             	add    $0x20,%edx
  80121b:	88 10                	mov    %dl,(%eax)
  80121d:	eb 14                	jmp    801233 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	01 c2                	add    %eax,%edx
  801227:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c8                	add    %ecx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801233:	ff 45 fc             	incl   -0x4(%ebp)
  801236:	ff 75 0c             	pushl  0xc(%ebp)
  801239:	e8 95 f8 ff ff       	call   800ad3 <strlen>
  80123e:	83 c4 04             	add    $0x4,%esp
  801241:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801244:	7f a4                	jg     8011ea <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
  801253:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801262:	8b 7d 18             	mov    0x18(%ebp),%edi
  801265:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801268:	cd 30                	int    $0x30
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    

00801278 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801284:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	52                   	push   %edx
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	6a 00                	push   $0x0
  801296:	e8 b2 ff ff ff       	call   80124d <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	90                   	nop
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 01                	push   $0x1
  8012b0:	e8 98 ff ff ff       	call   80124d <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	52                   	push   %edx
  8012ca:	50                   	push   %eax
  8012cb:	6a 05                	push   $0x5
  8012cd:	e8 7b ff ff ff       	call   80124d <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	56                   	push   %esi
  8012db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8012df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	56                   	push   %esi
  8012ec:	53                   	push   %ebx
  8012ed:	51                   	push   %ecx
  8012ee:	52                   	push   %edx
  8012ef:	50                   	push   %eax
  8012f0:	6a 06                	push   $0x6
  8012f2:	e8 56 ff ff ff       	call   80124d <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5e                   	pop    %esi
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	52                   	push   %edx
  801311:	50                   	push   %eax
  801312:	6a 07                	push   $0x7
  801314:	e8 34 ff ff ff       	call   80124d <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	ff 75 0c             	pushl  0xc(%ebp)
  80132a:	ff 75 08             	pushl  0x8(%ebp)
  80132d:	6a 08                	push   $0x8
  80132f:	e8 19 ff ff ff       	call   80124d <syscall>
  801334:	83 c4 18             	add    $0x18,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 09                	push   $0x9
  801348:	e8 00 ff ff ff       	call   80124d <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 0a                	push   $0xa
  801361:	e8 e7 fe ff ff       	call   80124d <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 0b                	push   $0xb
  80137a:	e8 ce fe ff ff       	call   80124d <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 0c                	push   $0xc
  801393:	e8 b5 fe ff ff       	call   80124d <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	ff 75 08             	pushl  0x8(%ebp)
  8013ab:	6a 0d                	push   $0xd
  8013ad:	e8 9b fe ff ff       	call   80124d <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 0e                	push   $0xe
  8013c6:	e8 82 fe ff ff       	call   80124d <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	90                   	nop
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 11                	push   $0x11
  8013e0:	e8 68 fe ff ff       	call   80124d <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	90                   	nop
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 12                	push   $0x12
  8013fa:	e8 4e fe ff ff       	call   80124d <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_cputc>:


void
sys_cputc(const char c)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801411:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	50                   	push   %eax
  80141e:	6a 13                	push   $0x13
  801420:	e8 28 fe ff ff       	call   80124d <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 14                	push   $0x14
  80143a:	e8 0e fe ff ff       	call   80124d <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
}
  801442:	90                   	nop
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	ff 75 0c             	pushl  0xc(%ebp)
  801454:	50                   	push   %eax
  801455:	6a 15                	push   $0x15
  801457:	e8 f1 fd ff ff       	call   80124d <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	6a 18                	push   $0x18
  801474:	e8 d4 fd ff ff       	call   80124d <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	52                   	push   %edx
  80148e:	50                   	push   %eax
  80148f:	6a 16                	push   $0x16
  801491:	e8 b7 fd ff ff       	call   80124d <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	52                   	push   %edx
  8014ac:	50                   	push   %eax
  8014ad:	6a 17                	push   $0x17
  8014af:	e8 99 fd ff ff       	call   80124d <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	6a 00                	push   $0x0
  8014d2:	51                   	push   %ecx
  8014d3:	52                   	push   %edx
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	50                   	push   %eax
  8014d8:	6a 19                	push   $0x19
  8014da:	e8 6e fd ff ff       	call   80124d <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	52                   	push   %edx
  8014f4:	50                   	push   %eax
  8014f5:	6a 1a                	push   $0x1a
  8014f7:	e8 51 fd ff ff       	call   80124d <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801504:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	51                   	push   %ecx
  801512:	52                   	push   %edx
  801513:	50                   	push   %eax
  801514:	6a 1b                	push   $0x1b
  801516:	e8 32 fd ff ff       	call   80124d <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801523:	8b 55 0c             	mov    0xc(%ebp),%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	52                   	push   %edx
  801530:	50                   	push   %eax
  801531:	6a 1c                	push   $0x1c
  801533:	e8 15 fd ff ff       	call   80124d <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 1d                	push   $0x1d
  80154c:	e8 fc fc ff ff       	call   80124d <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	ff 75 14             	pushl  0x14(%ebp)
  801561:	ff 75 10             	pushl  0x10(%ebp)
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	50                   	push   %eax
  801568:	6a 1e                	push   $0x1e
  80156a:	e8 de fc ff ff       	call   80124d <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	50                   	push   %eax
  801583:	6a 1f                	push   $0x1f
  801585:	e8 c3 fc ff ff       	call   80124d <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	90                   	nop
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	50                   	push   %eax
  80159f:	6a 20                	push   $0x20
  8015a1:	e8 a7 fc ff ff       	call   80124d <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 02                	push   $0x2
  8015ba:	e8 8e fc ff ff       	call   80124d <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 03                	push   $0x3
  8015d3:	e8 75 fc ff ff       	call   80124d <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 04                	push   $0x4
  8015ec:	e8 5c fc ff ff       	call   80124d <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 21                	push   $0x21
  801605:	e8 43 fc ff ff       	call   80124d <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801616:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801619:	8d 50 04             	lea    0x4(%eax),%edx
  80161c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	52                   	push   %edx
  801626:	50                   	push   %eax
  801627:	6a 22                	push   $0x22
  801629:	e8 1f fc ff ff       	call   80124d <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
	return result;
  801631:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801634:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	89 01                	mov    %eax,(%ecx)
  80163c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	c9                   	leave  
  801643:	c2 04 00             	ret    $0x4

00801646 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	ff 75 10             	pushl  0x10(%ebp)
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 10                	push   $0x10
  801658:	e8 f0 fb ff ff       	call   80124d <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
	return ;
  801660:	90                   	nop
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_rcr2>:
uint32 sys_rcr2()
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 23                	push   $0x23
  801672:	e8 d6 fb ff ff       	call   80124d <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801688:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	50                   	push   %eax
  801695:	6a 24                	push   $0x24
  801697:	e8 b1 fb ff ff       	call   80124d <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
	return ;
  80169f:	90                   	nop
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <rsttst>:
void rsttst()
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 26                	push   $0x26
  8016b1:	e8 97 fb ff ff       	call   80124d <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b9:	90                   	nop
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8016cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	ff 75 10             	pushl  0x10(%ebp)
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	6a 25                	push   $0x25
  8016dc:	e8 6c fb ff ff       	call   80124d <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e4:	90                   	nop
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <chktst>:
void chktst(uint32 n)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	6a 27                	push   $0x27
  8016f7:	e8 51 fb ff ff       	call   80124d <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ff:	90                   	nop
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <inctst>:

void inctst()
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 28                	push   $0x28
  801711:	e8 37 fb ff ff       	call   80124d <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
	return ;
  801719:	90                   	nop
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <gettst>:
uint32 gettst()
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 29                	push   $0x29
  80172b:	e8 1d fb ff ff       	call   80124d <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 2a                	push   $0x2a
  801747:	e8 01 fb ff ff       	call   80124d <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
  80174f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801752:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801756:	75 07                	jne    80175f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801758:	b8 01 00 00 00       	mov    $0x1,%eax
  80175d:	eb 05                	jmp    801764 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 2a                	push   $0x2a
  801778:	e8 d0 fa ff ff       	call   80124d <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
  801780:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801783:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801787:	75 07                	jne    801790 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801789:	b8 01 00 00 00       	mov    $0x1,%eax
  80178e:	eb 05                	jmp    801795 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 2a                	push   $0x2a
  8017a9:	e8 9f fa ff ff       	call   80124d <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
  8017b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017b8:	75 07                	jne    8017c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bf:	eb 05                	jmp    8017c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 2a                	push   $0x2a
  8017da:	e8 6e fa ff ff       	call   80124d <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
  8017e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017e9:	75 07                	jne    8017f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f0:	eb 05                	jmp    8017f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 2b                	push   $0x2b
  801809:	e8 3f fa ff ff       	call   80124d <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801818:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	53                   	push   %ebx
  801827:	51                   	push   %ecx
  801828:	52                   	push   %edx
  801829:	50                   	push   %eax
  80182a:	6a 2c                	push   $0x2c
  80182c:	e8 1c fa ff ff       	call   80124d <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	6a 2d                	push   $0x2d
  80184c:	e8 fc f9 ff ff       	call   80124d <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801859:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	51                   	push   %ecx
  801865:	ff 75 10             	pushl  0x10(%ebp)
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 2e                	push   $0x2e
  80186c:	e8 dc f9 ff ff       	call   80124d <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 10             	pushl  0x10(%ebp)
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	ff 75 08             	pushl  0x8(%ebp)
  801886:	6a 0f                	push   $0xf
  801888:	e8 c0 f9 ff ff       	call   80124d <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
	return ;
  801890:	90                   	nop
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	50                   	push   %eax
  8018a2:	6a 2f                	push   $0x2f
  8018a4:	e8 a4 f9 ff ff       	call   80124d <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp

}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 30                	push   $0x30
  8018bf:	e8 89 f9 ff ff       	call   80124d <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 31                	push   $0x31
  8018db:	e8 6d f9 ff ff       	call   80124d <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 32                	push   $0x32
  8018f5:	e8 53 f9 ff ff       	call   80124d <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	50                   	push   %eax
  80190e:	6a 33                	push   $0x33
  801910:	e8 38 f9 ff ff       	call   80124d <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
  80191b:	90                   	nop

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
