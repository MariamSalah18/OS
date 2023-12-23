
obj/user/tst_syscalls_2_slave3:     file format elf32-i386


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
  800031:	e8 36 00 00 00       	call   80006c <libmain>
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
	//[2] Invalid Range (Cross USER_LIMIT)
	sys_free_user_mem(USER_LIMIT - PAGE_SIZE, PAGE_SIZE + 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	68 0a 10 00 00       	push   $0x100a
  800046:	68 00 f0 7f ef       	push   $0xef7ff000
  80004b:	e8 62 18 00 00       	call   8018b2 <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 ae 16 00 00       	call   801706 <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 a0 1b 80 00       	push   $0x801ba0
  800060:	6a 0a                	push   $0xa
  800062:	68 1e 1c 80 00       	push   $0x801c1e
  800067:	e8 2e 01 00 00       	call   80019a <_panic>

0080006c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800072:	e8 51 15 00 00       	call   8015c8 <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	01 c0                	add    %eax,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	c1 e0 06             	shl    $0x6,%eax
  800086:	29 d0                	sub    %edx,%eax
  800088:	c1 e0 03             	shl    $0x3,%eax
  80008b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800090:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800095:	a1 20 30 80 00       	mov    0x803020,%eax
  80009a:	8a 40 68             	mov    0x68(%eax),%al
  80009d:	84 c0                	test   %al,%al
  80009f:	74 0d                	je     8000ae <libmain+0x42>
		binaryname = myEnv->prog_name;
  8000a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a6:	83 c0 68             	add    $0x68,%eax
  8000a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b2:	7e 0a                	jle    8000be <libmain+0x52>
		binaryname = argv[0];
  8000b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b7:	8b 00                	mov    (%eax),%eax
  8000b9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 0c             	pushl  0xc(%ebp)
  8000c4:	ff 75 08             	pushl  0x8(%ebp)
  8000c7:	e8 6c ff ff ff       	call   800038 <_main>
  8000cc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000cf:	e8 01 13 00 00       	call   8013d5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 54 1c 80 00       	push   $0x801c54
  8000dc:	e8 76 03 00 00       	call   800457 <cprintf>
  8000e1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e9:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f4:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 7c 1c 80 00       	push   $0x801c7c
  800104:	e8 4e 03 00 00       	call   800457 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800117:	a1 20 30 80 00       	mov    0x803020,%eax
  80011c:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800122:	a1 20 30 80 00       	mov    0x803020,%eax
  800127:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80012d:	51                   	push   %ecx
  80012e:	52                   	push   %edx
  80012f:	50                   	push   %eax
  800130:	68 a4 1c 80 00       	push   $0x801ca4
  800135:	e8 1d 03 00 00       	call   800457 <cprintf>
  80013a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80013d:	a1 20 30 80 00       	mov    0x803020,%eax
  800142:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	68 fc 1c 80 00       	push   $0x801cfc
  800151:	e8 01 03 00 00       	call   800457 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800159:	83 ec 0c             	sub    $0xc,%esp
  80015c:	68 54 1c 80 00       	push   $0x801c54
  800161:	e8 f1 02 00 00       	call   800457 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800169:	e8 81 12 00 00       	call   8013ef <sys_enable_interrupt>

	// exit gracefully
	exit();
  80016e:	e8 19 00 00 00       	call   80018c <exit>
}
  800173:	90                   	nop
  800174:	c9                   	leave  
  800175:	c3                   	ret    

00800176 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	6a 00                	push   $0x0
  800181:	e8 0e 14 00 00       	call   801594 <sys_destroy_env>
  800186:	83 c4 10             	add    $0x10,%esp
}
  800189:	90                   	nop
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <exit>:

void
exit(void)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800192:	e8 63 14 00 00       	call   8015fa <sys_exit_env>
}
  800197:	90                   	nop
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a3:	83 c0 04             	add    $0x4,%eax
  8001a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001a9:	a1 18 31 80 00       	mov    0x803118,%eax
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 16                	je     8001c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b2:	a1 18 31 80 00       	mov    0x803118,%eax
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	50                   	push   %eax
  8001bb:	68 10 1d 80 00       	push   $0x801d10
  8001c0:	e8 92 02 00 00       	call   800457 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001c8:	a1 00 30 80 00       	mov    0x803000,%eax
  8001cd:	ff 75 0c             	pushl  0xc(%ebp)
  8001d0:	ff 75 08             	pushl  0x8(%ebp)
  8001d3:	50                   	push   %eax
  8001d4:	68 15 1d 80 00       	push   $0x801d15
  8001d9:	e8 79 02 00 00       	call   800457 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ea:	50                   	push   %eax
  8001eb:	e8 fc 01 00 00       	call   8003ec <vcprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	6a 00                	push   $0x0
  8001f8:	68 31 1d 80 00       	push   $0x801d31
  8001fd:	e8 ea 01 00 00       	call   8003ec <vcprintf>
  800202:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800205:	e8 82 ff ff ff       	call   80018c <exit>

	// should not return here
	while (1) ;
  80020a:	eb fe                	jmp    80020a <_panic+0x70>

0080020c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80021d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800220:	39 c2                	cmp    %eax,%edx
  800222:	74 14                	je     800238 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 34 1d 80 00       	push   $0x801d34
  80022c:	6a 26                	push   $0x26
  80022e:	68 80 1d 80 00       	push   $0x801d80
  800233:	e8 62 ff ff ff       	call   80019a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80023f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800246:	e9 c5 00 00 00       	jmp    800310 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80024b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80024e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800255:	8b 45 08             	mov    0x8(%ebp),%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	8b 00                	mov    (%eax),%eax
  80025c:	85 c0                	test   %eax,%eax
  80025e:	75 08                	jne    800268 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800260:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800263:	e9 a5 00 00 00       	jmp    80030d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800268:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80026f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800276:	eb 69                	jmp    8002e1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800283:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800286:	89 d0                	mov    %edx,%eax
  800288:	01 c0                	add    %eax,%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	c1 e0 03             	shl    $0x3,%eax
  80028f:	01 c8                	add    %ecx,%eax
  800291:	8a 40 04             	mov    0x4(%eax),%al
  800294:	84 c0                	test   %al,%al
  800296:	75 46                	jne    8002de <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800298:	a1 20 30 80 00       	mov    0x803020,%eax
  80029d:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a6:	89 d0                	mov    %edx,%eax
  8002a8:	01 c0                	add    %eax,%eax
  8002aa:	01 d0                	add    %edx,%eax
  8002ac:	c1 e0 03             	shl    $0x3,%eax
  8002af:	01 c8                	add    %ecx,%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cd:	01 c8                	add    %ecx,%eax
  8002cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d1:	39 c2                	cmp    %eax,%edx
  8002d3:	75 09                	jne    8002de <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002dc:	eb 15                	jmp    8002f3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002de:	ff 45 e8             	incl   -0x18(%ebp)
  8002e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e6:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8002ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ef:	39 c2                	cmp    %eax,%edx
  8002f1:	77 85                	ja     800278 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002f7:	75 14                	jne    80030d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 8c 1d 80 00       	push   $0x801d8c
  800301:	6a 3a                	push   $0x3a
  800303:	68 80 1d 80 00       	push   $0x801d80
  800308:	e8 8d fe ff ff       	call   80019a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80030d:	ff 45 f0             	incl   -0x10(%ebp)
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800316:	0f 8c 2f ff ff ff    	jl     80024b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80031c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800323:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80032a:	eb 26                	jmp    800352 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80032c:	a1 20 30 80 00       	mov    0x803020,%eax
  800331:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800337:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033a:	89 d0                	mov    %edx,%eax
  80033c:	01 c0                	add    %eax,%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	c1 e0 03             	shl    $0x3,%eax
  800343:	01 c8                	add    %ecx,%eax
  800345:	8a 40 04             	mov    0x4(%eax),%al
  800348:	3c 01                	cmp    $0x1,%al
  80034a:	75 03                	jne    80034f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80034c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034f:	ff 45 e0             	incl   -0x20(%ebp)
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80035d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800360:	39 c2                	cmp    %eax,%edx
  800362:	77 c8                	ja     80032c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800367:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80036a:	74 14                	je     800380 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	68 e0 1d 80 00       	push   $0x801de0
  800374:	6a 44                	push   $0x44
  800376:	68 80 1d 80 00       	push   $0x801d80
  80037b:	e8 1a fe ff ff       	call   80019a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800380:	90                   	nop
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	8d 48 01             	lea    0x1(%eax),%ecx
  800391:	8b 55 0c             	mov    0xc(%ebp),%edx
  800394:	89 0a                	mov    %ecx,(%edx)
  800396:	8b 55 08             	mov    0x8(%ebp),%edx
  800399:	88 d1                	mov    %dl,%cl
  80039b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ac:	75 2c                	jne    8003da <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ae:	a0 24 30 80 00       	mov    0x803024,%al
  8003b3:	0f b6 c0             	movzbl %al,%eax
  8003b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b9:	8b 12                	mov    (%edx),%edx
  8003bb:	89 d1                	mov    %edx,%ecx
  8003bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c0:	83 c2 08             	add    $0x8,%edx
  8003c3:	83 ec 04             	sub    $0x4,%esp
  8003c6:	50                   	push   %eax
  8003c7:	51                   	push   %ecx
  8003c8:	52                   	push   %edx
  8003c9:	e8 ae 0e 00 00       	call   80127c <sys_cputs>
  8003ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	8b 40 04             	mov    0x4(%eax),%eax
  8003e0:	8d 50 01             	lea    0x1(%eax),%edx
  8003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e9:	90                   	nop
  8003ea:	c9                   	leave  
  8003eb:	c3                   	ret    

008003ec <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003fc:	00 00 00 
	b.cnt = 0;
  8003ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800406:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800415:	50                   	push   %eax
  800416:	68 83 03 80 00       	push   $0x800383
  80041b:	e8 11 02 00 00       	call   800631 <vprintfmt>
  800420:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800423:	a0 24 30 80 00       	mov    0x803024,%al
  800428:	0f b6 c0             	movzbl %al,%eax
  80042b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	50                   	push   %eax
  800435:	52                   	push   %edx
  800436:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043c:	83 c0 08             	add    $0x8,%eax
  80043f:	50                   	push   %eax
  800440:	e8 37 0e 00 00       	call   80127c <sys_cputs>
  800445:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800448:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80044f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <cprintf>:

int cprintf(const char *fmt, ...) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80045d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800464:	8d 45 0c             	lea    0xc(%ebp),%eax
  800467:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 f4             	pushl  -0xc(%ebp)
  800473:	50                   	push   %eax
  800474:	e8 73 ff ff ff       	call   8003ec <vcprintf>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048a:	e8 46 0f 00 00       	call   8013d5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800492:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 f4             	pushl  -0xc(%ebp)
  80049e:	50                   	push   %eax
  80049f:	e8 48 ff ff ff       	call   8003ec <vcprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004aa:	e8 40 0f 00 00       	call   8013ef <sys_enable_interrupt>
	return cnt;
  8004af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 14             	sub    $0x14,%esp
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d2:	77 55                	ja     800529 <printnum+0x75>
  8004d4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d7:	72 05                	jb     8004de <printnum+0x2a>
  8004d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004dc:	77 4b                	ja     800529 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004de:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	52                   	push   %edx
  8004ed:	50                   	push   %eax
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f4:	e8 27 14 00 00       	call   801920 <__udivdi3>
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	ff 75 20             	pushl  0x20(%ebp)
  800502:	53                   	push   %ebx
  800503:	ff 75 18             	pushl  0x18(%ebp)
  800506:	52                   	push   %edx
  800507:	50                   	push   %eax
  800508:	ff 75 0c             	pushl  0xc(%ebp)
  80050b:	ff 75 08             	pushl  0x8(%ebp)
  80050e:	e8 a1 ff ff ff       	call   8004b4 <printnum>
  800513:	83 c4 20             	add    $0x20,%esp
  800516:	eb 1a                	jmp    800532 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 20             	pushl  0x20(%ebp)
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	ff d0                	call   *%eax
  800526:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800529:	ff 4d 1c             	decl   0x1c(%ebp)
  80052c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800530:	7f e6                	jg     800518 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800532:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800540:	53                   	push   %ebx
  800541:	51                   	push   %ecx
  800542:	52                   	push   %edx
  800543:	50                   	push   %eax
  800544:	e8 e7 14 00 00       	call   801a30 <__umoddi3>
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	05 54 20 80 00       	add    $0x802054,%eax
  800551:	8a 00                	mov    (%eax),%al
  800553:	0f be c0             	movsbl %al,%eax
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	ff 75 0c             	pushl  0xc(%ebp)
  80055c:	50                   	push   %eax
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	ff d0                	call   *%eax
  800562:	83 c4 10             	add    $0x10,%esp
}
  800565:	90                   	nop
  800566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800569:	c9                   	leave  
  80056a:	c3                   	ret    

0080056b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80056e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800572:	7e 1c                	jle    800590 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	8d 50 08             	lea    0x8(%eax),%edx
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	89 10                	mov    %edx,(%eax)
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	83 e8 08             	sub    $0x8,%eax
  800589:	8b 50 04             	mov    0x4(%eax),%edx
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	eb 40                	jmp    8005d0 <getuint+0x65>
	else if (lflag)
  800590:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800594:	74 1e                	je     8005b4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	8d 50 04             	lea    0x4(%eax),%edx
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 10                	mov    %edx,(%eax)
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	83 e8 04             	sub    $0x4,%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	eb 1c                	jmp    8005d0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	8d 50 04             	lea    0x4(%eax),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	89 10                	mov    %edx,(%eax)
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	83 e8 04             	sub    $0x4,%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d0:	5d                   	pop    %ebp
  8005d1:	c3                   	ret    

008005d2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d9:	7e 1c                	jle    8005f7 <getint+0x25>
		return va_arg(*ap, long long);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	8d 50 08             	lea    0x8(%eax),%edx
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	89 10                	mov    %edx,(%eax)
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	83 e8 08             	sub    $0x8,%eax
  8005f0:	8b 50 04             	mov    0x4(%eax),%edx
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	eb 38                	jmp    80062f <getint+0x5d>
	else if (lflag)
  8005f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fb:	74 1a                	je     800617 <getint+0x45>
		return va_arg(*ap, long);
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	8d 50 04             	lea    0x4(%eax),%edx
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	89 10                	mov    %edx,(%eax)
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	83 e8 04             	sub    $0x4,%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	99                   	cltd   
  800615:	eb 18                	jmp    80062f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	8d 50 04             	lea    0x4(%eax),%edx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	89 10                	mov    %edx,(%eax)
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	83 e8 04             	sub    $0x4,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	99                   	cltd   
}
  80062f:	5d                   	pop    %ebp
  800630:	c3                   	ret    

00800631 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	56                   	push   %esi
  800635:	53                   	push   %ebx
  800636:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	eb 17                	jmp    800652 <vprintfmt+0x21>
			if (ch == '\0')
  80063b:	85 db                	test   %ebx,%ebx
  80063d:	0f 84 af 03 00 00    	je     8009f2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	53                   	push   %ebx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800652:	8b 45 10             	mov    0x10(%ebp),%eax
  800655:	8d 50 01             	lea    0x1(%eax),%edx
  800658:	89 55 10             	mov    %edx,0x10(%ebp)
  80065b:	8a 00                	mov    (%eax),%al
  80065d:	0f b6 d8             	movzbl %al,%ebx
  800660:	83 fb 25             	cmp    $0x25,%ebx
  800663:	75 d6                	jne    80063b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800665:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800669:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800670:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800677:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80067e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8d 50 01             	lea    0x1(%eax),%edx
  80068b:	89 55 10             	mov    %edx,0x10(%ebp)
  80068e:	8a 00                	mov    (%eax),%al
  800690:	0f b6 d8             	movzbl %al,%ebx
  800693:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800696:	83 f8 55             	cmp    $0x55,%eax
  800699:	0f 87 2b 03 00 00    	ja     8009ca <vprintfmt+0x399>
  80069f:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  8006a6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006a8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006ac:	eb d7                	jmp    800685 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ae:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b2:	eb d1                	jmp    800685 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006be:	89 d0                	mov    %edx,%eax
  8006c0:	c1 e0 02             	shl    $0x2,%eax
  8006c3:	01 d0                	add    %edx,%eax
  8006c5:	01 c0                	add    %eax,%eax
  8006c7:	01 d8                	add    %ebx,%eax
  8006c9:	83 e8 30             	sub    $0x30,%eax
  8006cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d2:	8a 00                	mov    (%eax),%al
  8006d4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d7:	83 fb 2f             	cmp    $0x2f,%ebx
  8006da:	7e 3e                	jle    80071a <vprintfmt+0xe9>
  8006dc:	83 fb 39             	cmp    $0x39,%ebx
  8006df:	7f 39                	jg     80071a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e4:	eb d5                	jmp    8006bb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	83 c0 04             	add    $0x4,%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	83 e8 04             	sub    $0x4,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fa:	eb 1f                	jmp    80071b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	79 83                	jns    800685 <vprintfmt+0x54>
				width = 0;
  800702:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800709:	e9 77 ff ff ff       	jmp    800685 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80070e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800715:	e9 6b ff ff ff       	jmp    800685 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071f:	0f 89 60 ff ff ff    	jns    800685 <vprintfmt+0x54>
				width = precision, precision = -1;
  800725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800732:	e9 4e ff ff ff       	jmp    800685 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800737:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073a:	e9 46 ff ff ff       	jmp    800685 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	83 c0 04             	add    $0x4,%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	83 e8 04             	sub    $0x4,%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
			break;
  80075f:	e9 89 02 00 00       	jmp    8009ed <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 c0 04             	add    $0x4,%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	83 e8 04             	sub    $0x4,%eax
  800773:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800775:	85 db                	test   %ebx,%ebx
  800777:	79 02                	jns    80077b <vprintfmt+0x14a>
				err = -err;
  800779:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077b:	83 fb 64             	cmp    $0x64,%ebx
  80077e:	7f 0b                	jg     80078b <vprintfmt+0x15a>
  800780:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  800787:	85 f6                	test   %esi,%esi
  800789:	75 19                	jne    8007a4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078b:	53                   	push   %ebx
  80078c:	68 65 20 80 00       	push   $0x802065
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	ff 75 08             	pushl  0x8(%ebp)
  800797:	e8 5e 02 00 00       	call   8009fa <printfmt>
  80079c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80079f:	e9 49 02 00 00       	jmp    8009ed <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a4:	56                   	push   %esi
  8007a5:	68 6e 20 80 00       	push   $0x80206e
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	ff 75 08             	pushl  0x8(%ebp)
  8007b0:	e8 45 02 00 00       	call   8009fa <printfmt>
  8007b5:	83 c4 10             	add    $0x10,%esp
			break;
  8007b8:	e9 30 02 00 00       	jmp    8009ed <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 c0 04             	add    $0x4,%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	83 e8 04             	sub    $0x4,%eax
  8007cc:	8b 30                	mov    (%eax),%esi
  8007ce:	85 f6                	test   %esi,%esi
  8007d0:	75 05                	jne    8007d7 <vprintfmt+0x1a6>
				p = "(null)";
  8007d2:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  8007d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007db:	7e 6d                	jle    80084a <vprintfmt+0x219>
  8007dd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e1:	74 67                	je     80084a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	50                   	push   %eax
  8007ea:	56                   	push   %esi
  8007eb:	e8 0c 03 00 00       	call   800afc <strnlen>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f6:	eb 16                	jmp    80080e <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007f8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	50                   	push   %eax
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	ff d0                	call   *%eax
  800808:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080b:	ff 4d e4             	decl   -0x1c(%ebp)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	7f e4                	jg     8007f8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800814:	eb 34                	jmp    80084a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800816:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081a:	74 1c                	je     800838 <vprintfmt+0x207>
  80081c:	83 fb 1f             	cmp    $0x1f,%ebx
  80081f:	7e 05                	jle    800826 <vprintfmt+0x1f5>
  800821:	83 fb 7e             	cmp    $0x7e,%ebx
  800824:	7e 12                	jle    800838 <vprintfmt+0x207>
					putch('?', putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	6a 3f                	push   $0x3f
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	ff d0                	call   *%eax
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	eb 0f                	jmp    800847 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	53                   	push   %ebx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800847:	ff 4d e4             	decl   -0x1c(%ebp)
  80084a:	89 f0                	mov    %esi,%eax
  80084c:	8d 70 01             	lea    0x1(%eax),%esi
  80084f:	8a 00                	mov    (%eax),%al
  800851:	0f be d8             	movsbl %al,%ebx
  800854:	85 db                	test   %ebx,%ebx
  800856:	74 24                	je     80087c <vprintfmt+0x24b>
  800858:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085c:	78 b8                	js     800816 <vprintfmt+0x1e5>
  80085e:	ff 4d e0             	decl   -0x20(%ebp)
  800861:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800865:	79 af                	jns    800816 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800867:	eb 13                	jmp    80087c <vprintfmt+0x24b>
				putch(' ', putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	6a 20                	push   $0x20
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800879:	ff 4d e4             	decl   -0x1c(%ebp)
  80087c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800880:	7f e7                	jg     800869 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800882:	e9 66 01 00 00       	jmp    8009ed <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 e8             	pushl  -0x18(%ebp)
  80088d:	8d 45 14             	lea    0x14(%ebp),%eax
  800890:	50                   	push   %eax
  800891:	e8 3c fd ff ff       	call   8005d2 <getint>
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80089f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a5:	85 d2                	test   %edx,%edx
  8008a7:	79 23                	jns    8008cc <vprintfmt+0x29b>
				putch('-', putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	6a 2d                	push   $0x2d
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bf:	f7 d8                	neg    %eax
  8008c1:	83 d2 00             	adc    $0x0,%edx
  8008c4:	f7 da                	neg    %edx
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d3:	e9 bc 00 00 00       	jmp    800994 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 e8             	pushl  -0x18(%ebp)
  8008de:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e1:	50                   	push   %eax
  8008e2:	e8 84 fc ff ff       	call   80056b <getuint>
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f7:	e9 98 00 00 00       	jmp    800994 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	ff 75 0c             	pushl  0xc(%ebp)
  800902:	6a 58                	push   $0x58
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	6a 58                	push   $0x58
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	6a 58                	push   $0x58
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	ff d0                	call   *%eax
  800929:	83 c4 10             	add    $0x10,%esp
			break;
  80092c:	e9 bc 00 00 00       	jmp    8009ed <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800931:	83 ec 08             	sub    $0x8,%esp
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	6a 30                	push   $0x30
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	ff d0                	call   *%eax
  80093e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	6a 78                	push   $0x78
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800962:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800965:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800973:	eb 1f                	jmp    800994 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 e8             	pushl  -0x18(%ebp)
  80097b:	8d 45 14             	lea    0x14(%ebp),%eax
  80097e:	50                   	push   %eax
  80097f:	e8 e7 fb ff ff       	call   80056b <getuint>
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80098d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800994:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099b:	83 ec 04             	sub    $0x4,%esp
  80099e:	52                   	push   %edx
  80099f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a2:	50                   	push   %eax
  8009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 00 fb ff ff       	call   8004b4 <printnum>
  8009b4:	83 c4 20             	add    $0x20,%esp
			break;
  8009b7:	eb 34                	jmp    8009ed <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	53                   	push   %ebx
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
			break;
  8009c8:	eb 23                	jmp    8009ed <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 25                	push   $0x25
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009da:	ff 4d 10             	decl   0x10(%ebp)
  8009dd:	eb 03                	jmp    8009e2 <vprintfmt+0x3b1>
  8009df:	ff 4d 10             	decl   0x10(%ebp)
  8009e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e5:	48                   	dec    %eax
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	3c 25                	cmp    $0x25,%al
  8009ea:	75 f3                	jne    8009df <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ec:	90                   	nop
		}
	}
  8009ed:	e9 47 fc ff ff       	jmp    800639 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a00:	8d 45 10             	lea    0x10(%ebp),%eax
  800a03:	83 c0 04             	add    $0x4,%eax
  800a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a09:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0f:	50                   	push   %eax
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	ff 75 08             	pushl  0x8(%ebp)
  800a16:	e8 16 fc ff ff       	call   800631 <vprintfmt>
  800a1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a1e:	90                   	nop
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a27:	8b 40 08             	mov    0x8(%eax),%eax
  800a2a:	8d 50 01             	lea    0x1(%eax),%edx
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 10                	mov    (%eax),%edx
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8b 40 04             	mov    0x4(%eax),%eax
  800a3e:	39 c2                	cmp    %eax,%edx
  800a40:	73 12                	jae    800a54 <sprintputch+0x33>
		*b->buf++ = ch;
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	89 0a                	mov    %ecx,(%edx)
  800a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a52:	88 10                	mov    %dl,(%eax)
}
  800a54:	90                   	nop
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	01 d0                	add    %edx,%eax
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7c:	74 06                	je     800a84 <vsnprintf+0x2d>
  800a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a82:	7f 07                	jg     800a8b <vsnprintf+0x34>
		return -E_INVAL;
  800a84:	b8 03 00 00 00       	mov    $0x3,%eax
  800a89:	eb 20                	jmp    800aab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8b:	ff 75 14             	pushl  0x14(%ebp)
  800a8e:	ff 75 10             	pushl  0x10(%ebp)
  800a91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a94:	50                   	push   %eax
  800a95:	68 21 0a 80 00       	push   $0x800a21
  800a9a:	e8 92 fb ff ff       	call   800631 <vprintfmt>
  800a9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
  800abf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 89 ff ff ff       	call   800a57 <vsnprintf>
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800adf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae6:	eb 06                	jmp    800aee <strlen+0x15>
		n++;
  800ae8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aeb:	ff 45 08             	incl   0x8(%ebp)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 f1                	jne    800ae8 <strlen+0xf>
		n++;
	return n;
  800af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b09:	eb 09                	jmp    800b14 <strnlen+0x18>
		n++;
  800b0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 4d 0c             	decl   0xc(%ebp)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 09                	je     800b23 <strnlen+0x27>
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	84 c0                	test   %al,%al
  800b21:	75 e8                	jne    800b0b <strnlen+0xf>
		n++;
	return n;
  800b23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b34:	90                   	nop
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8d 50 01             	lea    0x1(%eax),%edx
  800b3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b47:	8a 12                	mov    (%edx),%dl
  800b49:	88 10                	mov    %dl,(%eax)
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	84 c0                	test   %al,%al
  800b4f:	75 e4                	jne    800b35 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b69:	eb 1f                	jmp    800b8a <strncpy+0x34>
		*dst++ = *src;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8d 50 01             	lea    0x1(%eax),%edx
  800b71:	89 55 08             	mov    %edx,0x8(%ebp)
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	8a 12                	mov    (%edx),%dl
  800b79:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7e:	8a 00                	mov    (%eax),%al
  800b80:	84 c0                	test   %al,%al
  800b82:	74 03                	je     800b87 <strncpy+0x31>
			src++;
  800b84:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b87:	ff 45 fc             	incl   -0x4(%ebp)
  800b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b90:	72 d9                	jb     800b6b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba7:	74 30                	je     800bd9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba9:	eb 16                	jmp    800bc1 <strlcpy+0x2a>
			*dst++ = *src++;
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	8d 50 01             	lea    0x1(%eax),%edx
  800bb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bbd:	8a 12                	mov    (%edx),%dl
  800bbf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc1:	ff 4d 10             	decl   0x10(%ebp)
  800bc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc8:	74 09                	je     800bd3 <strlcpy+0x3c>
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 d8                	jne    800bab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdf:	29 c2                	sub    %eax,%edx
  800be1:	89 d0                	mov    %edx,%eax
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be8:	eb 06                	jmp    800bf0 <strcmp+0xb>
		p++, q++;
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	84 c0                	test   %al,%al
  800bf7:	74 0e                	je     800c07 <strcmp+0x22>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 10                	mov    (%eax),%dl
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	38 c2                	cmp    %al,%dl
  800c05:	74 e3                	je     800bea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	0f b6 d0             	movzbl %al,%edx
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	0f b6 c0             	movzbl %al,%eax
  800c17:	29 c2                	sub    %eax,%edx
  800c19:	89 d0                	mov    %edx,%eax
}
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c20:	eb 09                	jmp    800c2b <strncmp+0xe>
		n--, p++, q++;
  800c22:	ff 4d 10             	decl   0x10(%ebp)
  800c25:	ff 45 08             	incl   0x8(%ebp)
  800c28:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2f:	74 17                	je     800c48 <strncmp+0x2b>
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	84 c0                	test   %al,%al
  800c38:	74 0e                	je     800c48 <strncmp+0x2b>
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8a 10                	mov    (%eax),%dl
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	38 c2                	cmp    %al,%dl
  800c46:	74 da                	je     800c22 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4c:	75 07                	jne    800c55 <strncmp+0x38>
		return 0;
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c53:	eb 14                	jmp    800c69 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	0f b6 d0             	movzbl %al,%edx
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	0f b6 c0             	movzbl %al,%eax
  800c65:	29 c2                	sub    %eax,%edx
  800c67:	89 d0                	mov    %edx,%eax
}
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 04             	sub    $0x4,%esp
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c77:	eb 12                	jmp    800c8b <strchr+0x20>
		if (*s == c)
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c81:	75 05                	jne    800c88 <strchr+0x1d>
			return (char *) s;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	eb 11                	jmp    800c99 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	84 c0                	test   %al,%al
  800c92:	75 e5                	jne    800c79 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 04             	sub    $0x4,%esp
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca7:	eb 0d                	jmp    800cb6 <strfind+0x1b>
		if (*s == c)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb1:	74 0e                	je     800cc1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb3:	ff 45 08             	incl   0x8(%ebp)
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	75 ea                	jne    800ca9 <strfind+0xe>
  800cbf:	eb 01                	jmp    800cc2 <strfind+0x27>
		if (*s == c)
			break;
  800cc1:	90                   	nop
	return (char *) s;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd9:	eb 0e                	jmp    800ce9 <memset+0x22>
		*p++ = c;
  800cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cde:	8d 50 01             	lea    0x1(%eax),%edx
  800ce1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce9:	ff 4d f8             	decl   -0x8(%ebp)
  800cec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf0:	79 e9                	jns    800cdb <memset+0x14>
		*p++ = c;

	return v;
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d09:	eb 16                	jmp    800d21 <memcpy+0x2a>
		*d++ = *s++;
  800d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0e:	8d 50 01             	lea    0x1(%eax),%edx
  800d11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d1d:	8a 12                	mov    (%edx),%dl
  800d1f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d27:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	75 dd                	jne    800d0b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4b:	73 50                	jae    800d9d <memmove+0x6a>
  800d4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	01 d0                	add    %edx,%eax
  800d55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d58:	76 43                	jbe    800d9d <memmove+0x6a>
		s += n;
  800d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d66:	eb 10                	jmp    800d78 <memmove+0x45>
			*--d = *--s;
  800d68:	ff 4d f8             	decl   -0x8(%ebp)
  800d6b:	ff 4d fc             	decl   -0x4(%ebp)
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	8a 10                	mov    (%eax),%dl
  800d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d76:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	75 e3                	jne    800d68 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d85:	eb 23                	jmp    800daa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d99:	8a 12                	mov    (%edx),%dl
  800d9b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da3:	89 55 10             	mov    %edx,0x10(%ebp)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	75 dd                	jne    800d87 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc1:	eb 2a                	jmp    800ded <memcmp+0x3e>
		if (*s1 != *s2)
  800dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc6:	8a 10                	mov    (%eax),%dl
  800dc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	38 c2                	cmp    %al,%dl
  800dcf:	74 16                	je     800de7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f b6 d0             	movzbl %al,%edx
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	0f b6 c0             	movzbl %al,%eax
  800de1:	29 c2                	sub    %eax,%edx
  800de3:	89 d0                	mov    %edx,%eax
  800de5:	eb 18                	jmp    800dff <memcmp+0x50>
		s1++, s2++;
  800de7:	ff 45 fc             	incl   -0x4(%ebp)
  800dea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df3:	89 55 10             	mov    %edx,0x10(%ebp)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	75 c9                	jne    800dc3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	01 d0                	add    %edx,%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e12:	eb 15                	jmp    800e29 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 d0             	movzbl %al,%edx
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	0f b6 c0             	movzbl %al,%eax
  800e22:	39 c2                	cmp    %eax,%edx
  800e24:	74 0d                	je     800e33 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e2f:	72 e3                	jb     800e14 <memfind+0x13>
  800e31:	eb 01                	jmp    800e34 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e33:	90                   	nop
	return (void *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4d:	eb 03                	jmp    800e52 <strtol+0x19>
		s++;
  800e4f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	3c 20                	cmp    $0x20,%al
  800e59:	74 f4                	je     800e4f <strtol+0x16>
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	3c 09                	cmp    $0x9,%al
  800e62:	74 eb                	je     800e4f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	3c 2b                	cmp    $0x2b,%al
  800e6b:	75 05                	jne    800e72 <strtol+0x39>
		s++;
  800e6d:	ff 45 08             	incl   0x8(%ebp)
  800e70:	eb 13                	jmp    800e85 <strtol+0x4c>
	else if (*s == '-')
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 2d                	cmp    $0x2d,%al
  800e79:	75 0a                	jne    800e85 <strtol+0x4c>
		s++, neg = 1;
  800e7b:	ff 45 08             	incl   0x8(%ebp)
  800e7e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e89:	74 06                	je     800e91 <strtol+0x58>
  800e8b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e8f:	75 20                	jne    800eb1 <strtol+0x78>
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3c 30                	cmp    $0x30,%al
  800e98:	75 17                	jne    800eb1 <strtol+0x78>
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	40                   	inc    %eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	3c 78                	cmp    $0x78,%al
  800ea2:	75 0d                	jne    800eb1 <strtol+0x78>
		s += 2, base = 16;
  800ea4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eaf:	eb 28                	jmp    800ed9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb5:	75 15                	jne    800ecc <strtol+0x93>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	3c 30                	cmp    $0x30,%al
  800ebe:	75 0c                	jne    800ecc <strtol+0x93>
		s++, base = 8;
  800ec0:	ff 45 08             	incl   0x8(%ebp)
  800ec3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eca:	eb 0d                	jmp    800ed9 <strtol+0xa0>
	else if (base == 0)
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	75 07                	jne    800ed9 <strtol+0xa0>
		base = 10;
  800ed2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3c 2f                	cmp    $0x2f,%al
  800ee0:	7e 19                	jle    800efb <strtol+0xc2>
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	3c 39                	cmp    $0x39,%al
  800ee9:	7f 10                	jg     800efb <strtol+0xc2>
			dig = *s - '0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f be c0             	movsbl %al,%eax
  800ef3:	83 e8 30             	sub    $0x30,%eax
  800ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef9:	eb 42                	jmp    800f3d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 60                	cmp    $0x60,%al
  800f02:	7e 19                	jle    800f1d <strtol+0xe4>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 7a                	cmp    $0x7a,%al
  800f0b:	7f 10                	jg     800f1d <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	0f be c0             	movsbl %al,%eax
  800f15:	83 e8 57             	sub    $0x57,%eax
  800f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1b:	eb 20                	jmp    800f3d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 40                	cmp    $0x40,%al
  800f24:	7e 39                	jle    800f5f <strtol+0x126>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 5a                	cmp    $0x5a,%al
  800f2d:	7f 30                	jg     800f5f <strtol+0x126>
			dig = *s - 'A' + 10;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	0f be c0             	movsbl %al,%eax
  800f37:	83 e8 37             	sub    $0x37,%eax
  800f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f43:	7d 19                	jge    800f5e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f54:	01 d0                	add    %edx,%eax
  800f56:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f59:	e9 7b ff ff ff       	jmp    800ed9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f5e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f63:	74 08                	je     800f6d <strtol+0x134>
		*endptr = (char *) s;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f71:	74 07                	je     800f7a <strtol+0x141>
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f76:	f7 d8                	neg    %eax
  800f78:	eb 03                	jmp    800f7d <strtol+0x144>
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <ltostr>:

void
ltostr(long value, char *str)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f97:	79 13                	jns    800fac <ltostr+0x2d>
	{
		neg = 1;
  800f99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb4:	99                   	cltd   
  800fb5:	f7 f9                	idiv   %ecx
  800fb7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbd:	8d 50 01             	lea    0x1(%eax),%edx
  800fc0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc3:	89 c2                	mov    %eax,%edx
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	01 d0                	add    %edx,%eax
  800fca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fcd:	83 c2 30             	add    $0x30,%edx
  800fd0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fda:	f7 e9                	imul   %ecx
  800fdc:	c1 fa 02             	sar    $0x2,%edx
  800fdf:	89 c8                	mov    %ecx,%eax
  800fe1:	c1 f8 1f             	sar    $0x1f,%eax
  800fe4:	29 c2                	sub    %eax,%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff3:	f7 e9                	imul   %ecx
  800ff5:	c1 fa 02             	sar    $0x2,%edx
  800ff8:	89 c8                	mov    %ecx,%eax
  800ffa:	c1 f8 1f             	sar    $0x1f,%eax
  800ffd:	29 c2                	sub    %eax,%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	c1 e0 02             	shl    $0x2,%eax
  801004:	01 d0                	add    %edx,%eax
  801006:	01 c0                	add    %eax,%eax
  801008:	29 c1                	sub    %eax,%ecx
  80100a:	89 ca                	mov    %ecx,%edx
  80100c:	85 d2                	test   %edx,%edx
  80100e:	75 9c                	jne    800fac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801010:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101a:	48                   	dec    %eax
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801022:	74 3d                	je     801061 <ltostr+0xe2>
		start = 1 ;
  801024:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102b:	eb 34                	jmp    801061 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80102d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	01 c2                	add    %eax,%edx
  801042:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	01 c8                	add    %ecx,%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	01 c2                	add    %eax,%edx
  801056:	8a 45 eb             	mov    -0x15(%ebp),%al
  801059:	88 02                	mov    %al,(%edx)
		start++ ;
  80105b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801064:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801067:	7c c4                	jl     80102d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801069:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	01 d0                	add    %edx,%eax
  801071:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801074:	90                   	nop
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107d:	ff 75 08             	pushl  0x8(%ebp)
  801080:	e8 54 fa ff ff       	call   800ad9 <strlen>
  801085:	83 c4 04             	add    $0x4,%esp
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	e8 46 fa ff ff       	call   800ad9 <strlen>
  801093:	83 c4 04             	add    $0x4,%esp
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 17                	jmp    8010c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8010af:	01 c2                	add    %eax,%edx
  8010b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	01 c8                	add    %ecx,%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010bd:	ff 45 fc             	incl   -0x4(%ebp)
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c6:	7c e1                	jl     8010a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d6:	eb 1f                	jmp    8010f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	01 c2                	add    %eax,%edx
  8010e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	01 c8                	add    %ecx,%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f4:	ff 45 f8             	incl   -0x8(%ebp)
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fd:	7c d9                	jl     8010d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 d0                	add    %edx,%eax
  801107:	c6 00 00             	movb   $0x0,(%eax)
}
  80110a:	90                   	nop
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801110:	8b 45 14             	mov    0x14(%ebp),%eax
  801113:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801119:	8b 45 14             	mov    0x14(%ebp),%eax
  80111c:	8b 00                	mov    (%eax),%eax
  80111e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	01 d0                	add    %edx,%eax
  80112a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801130:	eb 0c                	jmp    80113e <strsplit+0x31>
			*string++ = 0;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8d 50 01             	lea    0x1(%eax),%edx
  801138:	89 55 08             	mov    %edx,0x8(%ebp)
  80113b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	84 c0                	test   %al,%al
  801145:	74 18                	je     80115f <strsplit+0x52>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f be c0             	movsbl %al,%eax
  80114f:	50                   	push   %eax
  801150:	ff 75 0c             	pushl  0xc(%ebp)
  801153:	e8 13 fb ff ff       	call   800c6b <strchr>
  801158:	83 c4 08             	add    $0x8,%esp
  80115b:	85 c0                	test   %eax,%eax
  80115d:	75 d3                	jne    801132 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	84 c0                	test   %al,%al
  801166:	74 5a                	je     8011c2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	8b 00                	mov    (%eax),%eax
  80116d:	83 f8 0f             	cmp    $0xf,%eax
  801170:	75 07                	jne    801179 <strsplit+0x6c>
		{
			return 0;
  801172:	b8 00 00 00 00       	mov    $0x0,%eax
  801177:	eb 66                	jmp    8011df <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801179:	8b 45 14             	mov    0x14(%ebp),%eax
  80117c:	8b 00                	mov    (%eax),%eax
  80117e:	8d 48 01             	lea    0x1(%eax),%ecx
  801181:	8b 55 14             	mov    0x14(%ebp),%edx
  801184:	89 0a                	mov    %ecx,(%edx)
  801186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	01 c2                	add    %eax,%edx
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801197:	eb 03                	jmp    80119c <strsplit+0x8f>
			string++;
  801199:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	84 c0                	test   %al,%al
  8011a3:	74 8b                	je     801130 <strsplit+0x23>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f be c0             	movsbl %al,%eax
  8011ad:	50                   	push   %eax
  8011ae:	ff 75 0c             	pushl  0xc(%ebp)
  8011b1:	e8 b5 fa ff ff       	call   800c6b <strchr>
  8011b6:	83 c4 08             	add    $0x8,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	74 dc                	je     801199 <strsplit+0x8c>
			string++;
	}
  8011bd:	e9 6e ff ff ff       	jmp    801130 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c6:	8b 00                	mov    (%eax),%eax
  8011c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8011e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ee:	eb 4c                	jmp    80123c <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8011f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	3c 40                	cmp    $0x40,%al
  8011fc:	7e 27                	jle    801225 <str2lower+0x44>
  8011fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 5a                	cmp    $0x5a,%al
  80120a:	7f 19                	jg     801225 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  80120c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121a:	01 ca                	add    %ecx,%edx
  80121c:	8a 12                	mov    (%edx),%dl
  80121e:	83 c2 20             	add    $0x20,%edx
  801221:	88 10                	mov    %dl,(%eax)
  801223:	eb 14                	jmp    801239 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801225:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	01 c2                	add    %eax,%edx
  80122d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 c8                	add    %ecx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801239:	ff 45 fc             	incl   -0x4(%ebp)
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	e8 95 f8 ff ff       	call   800ad9 <strlen>
  801244:	83 c4 04             	add    $0x4,%esp
  801247:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124a:	7f a4                	jg     8011f0 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801260:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801263:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801266:	8b 7d 18             	mov    0x18(%ebp),%edi
  801269:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80126c:	cd 30                	int    $0x30
  80126e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801271:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801288:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	52                   	push   %edx
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	50                   	push   %eax
  801298:	6a 00                	push   $0x0
  80129a:	e8 b2 ff ff ff       	call   801251 <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 01                	push   $0x1
  8012b4:	e8 98 ff ff ff       	call   801251 <syscall>
  8012b9:	83 c4 18             	add    $0x18,%esp
}
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	52                   	push   %edx
  8012ce:	50                   	push   %eax
  8012cf:	6a 05                	push   $0x5
  8012d1:	e8 7b ff ff ff       	call   801251 <syscall>
  8012d6:	83 c4 18             	add    $0x18,%esp
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012e0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	51                   	push   %ecx
  8012f2:	52                   	push   %edx
  8012f3:	50                   	push   %eax
  8012f4:	6a 06                	push   $0x6
  8012f6:	e8 56 ff ff ff       	call   801251 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	52                   	push   %edx
  801315:	50                   	push   %eax
  801316:	6a 07                	push   $0x7
  801318:	e8 34 ff ff ff       	call   801251 <syscall>
  80131d:	83 c4 18             	add    $0x18,%esp
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	ff 75 08             	pushl  0x8(%ebp)
  801331:	6a 08                	push   $0x8
  801333:	e8 19 ff ff ff       	call   801251 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 09                	push   $0x9
  80134c:	e8 00 ff ff ff       	call   801251 <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 0a                	push   $0xa
  801365:	e8 e7 fe ff ff       	call   801251 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 0b                	push   $0xb
  80137e:	e8 ce fe ff ff       	call   801251 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 0c                	push   $0xc
  801397:	e8 b5 fe ff ff       	call   801251 <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	6a 0d                	push   $0xd
  8013b1:	e8 9b fe ff ff       	call   801251 <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 0e                	push   $0xe
  8013ca:	e8 82 fe ff ff       	call   801251 <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	90                   	nop
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 11                	push   $0x11
  8013e4:	e8 68 fe ff ff       	call   801251 <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 12                	push   $0x12
  8013fe:	e8 4e fe ff ff       	call   801251 <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
}
  801406:	90                   	nop
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_cputc>:


void
sys_cputc(const char c)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801415:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	50                   	push   %eax
  801422:	6a 13                	push   $0x13
  801424:	e8 28 fe ff ff       	call   801251 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	90                   	nop
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 14                	push   $0x14
  80143e:	e8 0e fe ff ff       	call   801251 <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
}
  801446:	90                   	nop
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	50                   	push   %eax
  801459:	6a 15                	push   $0x15
  80145b:	e8 f1 fd ff ff       	call   801251 <syscall>
  801460:	83 c4 18             	add    $0x18,%esp
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	52                   	push   %edx
  801475:	50                   	push   %eax
  801476:	6a 18                	push   $0x18
  801478:	e8 d4 fd ff ff       	call   801251 <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	52                   	push   %edx
  801492:	50                   	push   %eax
  801493:	6a 16                	push   $0x16
  801495:	e8 b7 fd ff ff       	call   801251 <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	90                   	nop
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	52                   	push   %edx
  8014b0:	50                   	push   %eax
  8014b1:	6a 17                	push   $0x17
  8014b3:	e8 99 fd ff ff       	call   801251 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	51                   	push   %ecx
  8014d7:	52                   	push   %edx
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	50                   	push   %eax
  8014dc:	6a 19                	push   $0x19
  8014de:	e8 6e fd ff ff       	call   801251 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	52                   	push   %edx
  8014f8:	50                   	push   %eax
  8014f9:	6a 1a                	push   $0x1a
  8014fb:	e8 51 fd ff ff       	call   801251 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	51                   	push   %ecx
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	6a 1b                	push   $0x1b
  80151a:	e8 32 fd ff ff       	call   801251 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	52                   	push   %edx
  801534:	50                   	push   %eax
  801535:	6a 1c                	push   $0x1c
  801537:	e8 15 fd ff ff       	call   801251 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 1d                	push   $0x1d
  801550:	e8 fc fc ff ff       	call   801251 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	ff 75 14             	pushl  0x14(%ebp)
  801565:	ff 75 10             	pushl  0x10(%ebp)
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	50                   	push   %eax
  80156c:	6a 1e                	push   $0x1e
  80156e:	e8 de fc ff ff       	call   801251 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	50                   	push   %eax
  801587:	6a 1f                	push   $0x1f
  801589:	e8 c3 fc ff ff       	call   801251 <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	50                   	push   %eax
  8015a3:	6a 20                	push   $0x20
  8015a5:	e8 a7 fc ff ff       	call   801251 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 02                	push   $0x2
  8015be:	e8 8e fc ff ff       	call   801251 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 03                	push   $0x3
  8015d7:	e8 75 fc ff ff       	call   801251 <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 04                	push   $0x4
  8015f0:	e8 5c fc ff ff       	call   801251 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_exit_env>:


void sys_exit_env(void)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 21                	push   $0x21
  801609:	e8 43 fc ff ff       	call   801251 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	90                   	nop
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80161a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161d:	8d 50 04             	lea    0x4(%eax),%edx
  801620:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	52                   	push   %edx
  80162a:	50                   	push   %eax
  80162b:	6a 22                	push   $0x22
  80162d:	e8 1f fc ff ff       	call   801251 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return result;
  801635:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801638:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163e:	89 01                	mov    %eax,(%ecx)
  801640:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	c9                   	leave  
  801647:	c2 04 00             	ret    $0x4

0080164a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	ff 75 10             	pushl  0x10(%ebp)
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	6a 10                	push   $0x10
  80165c:	e8 f0 fb ff ff       	call   801251 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return ;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_rcr2>:
uint32 sys_rcr2()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 23                	push   $0x23
  801676:	e8 d6 fb ff ff       	call   801251 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80168c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	50                   	push   %eax
  801699:	6a 24                	push   $0x24
  80169b:	e8 b1 fb ff ff       	call   801251 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a3:	90                   	nop
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <rsttst>:
void rsttst()
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 26                	push   $0x26
  8016b5:	e8 97 fb ff ff       	call   801251 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bd:	90                   	nop
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016cc:	8b 55 18             	mov    0x18(%ebp),%edx
  8016cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	ff 75 10             	pushl  0x10(%ebp)
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	6a 25                	push   $0x25
  8016e0:	e8 6c fb ff ff       	call   801251 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e8:	90                   	nop
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <chktst>:
void chktst(uint32 n)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	ff 75 08             	pushl  0x8(%ebp)
  8016f9:	6a 27                	push   $0x27
  8016fb:	e8 51 fb ff ff       	call   801251 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
	return ;
  801703:	90                   	nop
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <inctst>:

void inctst()
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 28                	push   $0x28
  801715:	e8 37 fb ff ff       	call   801251 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
	return ;
  80171d:	90                   	nop
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <gettst>:
uint32 gettst()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 29                	push   $0x29
  80172f:	e8 1d fb ff ff       	call   801251 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 2a                	push   $0x2a
  80174b:	e8 01 fb ff ff       	call   801251 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
  801753:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801756:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80175a:	75 07                	jne    801763 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80175c:	b8 01 00 00 00       	mov    $0x1,%eax
  801761:	eb 05                	jmp    801768 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 2a                	push   $0x2a
  80177c:	e8 d0 fa ff ff       	call   801251 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
  801784:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801787:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80178b:	75 07                	jne    801794 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80178d:	b8 01 00 00 00       	mov    $0x1,%eax
  801792:	eb 05                	jmp    801799 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 2a                	push   $0x2a
  8017ad:	e8 9f fa ff ff       	call   801251 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
  8017b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017bc:	75 07                	jne    8017c5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017be:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c3:	eb 05                	jmp    8017ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 2a                	push   $0x2a
  8017de:	e8 6e fa ff ff       	call   801251 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
  8017e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017e9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ed:	75 07                	jne    8017f6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f4:	eb 05                	jmp    8017fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	6a 2b                	push   $0x2b
  80180d:	e8 3f fa ff ff       	call   801251 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
	return ;
  801815:	90                   	nop
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80181c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	53                   	push   %ebx
  80182b:	51                   	push   %ecx
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 2c                	push   $0x2c
  801830:	e8 1c fa ff ff       	call   801251 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 2d                	push   $0x2d
  801850:	e8 fc f9 ff ff       	call   801251 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80185d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801860:	8b 55 0c             	mov    0xc(%ebp),%edx
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	51                   	push   %ecx
  801869:	ff 75 10             	pushl  0x10(%ebp)
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	6a 2e                	push   $0x2e
  801870:	e8 dc f9 ff ff       	call   801251 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 10             	pushl  0x10(%ebp)
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 0f                	push   $0xf
  80188c:	e8 c0 f9 ff ff       	call   801251 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	50                   	push   %eax
  8018a6:	6a 2f                	push   $0x2f
  8018a8:	e8 a4 f9 ff ff       	call   801251 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp

}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	6a 30                	push   $0x30
  8018c3:	e8 89 f9 ff ff       	call   801251 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
	return;
  8018cb:	90                   	nop
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	6a 31                	push   $0x31
  8018df:	e8 6d f9 ff ff       	call   801251 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
	return;
  8018e7:	90                   	nop
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 32                	push   $0x32
  8018f9:	e8 53 f9 ff ff       	call   801251 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	50                   	push   %eax
  801912:	6a 33                	push   $0x33
  801914:	e8 38 f9 ff ff       	call   801251 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    
  80191f:	90                   	nop

00801920 <__udivdi3>:
  801920:	55                   	push   %ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 1c             	sub    $0x1c,%esp
  801927:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80192b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80192f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801933:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801937:	89 ca                	mov    %ecx,%edx
  801939:	89 f8                	mov    %edi,%eax
  80193b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80193f:	85 f6                	test   %esi,%esi
  801941:	75 2d                	jne    801970 <__udivdi3+0x50>
  801943:	39 cf                	cmp    %ecx,%edi
  801945:	77 65                	ja     8019ac <__udivdi3+0x8c>
  801947:	89 fd                	mov    %edi,%ebp
  801949:	85 ff                	test   %edi,%edi
  80194b:	75 0b                	jne    801958 <__udivdi3+0x38>
  80194d:	b8 01 00 00 00       	mov    $0x1,%eax
  801952:	31 d2                	xor    %edx,%edx
  801954:	f7 f7                	div    %edi
  801956:	89 c5                	mov    %eax,%ebp
  801958:	31 d2                	xor    %edx,%edx
  80195a:	89 c8                	mov    %ecx,%eax
  80195c:	f7 f5                	div    %ebp
  80195e:	89 c1                	mov    %eax,%ecx
  801960:	89 d8                	mov    %ebx,%eax
  801962:	f7 f5                	div    %ebp
  801964:	89 cf                	mov    %ecx,%edi
  801966:	89 fa                	mov    %edi,%edx
  801968:	83 c4 1c             	add    $0x1c,%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
  801970:	39 ce                	cmp    %ecx,%esi
  801972:	77 28                	ja     80199c <__udivdi3+0x7c>
  801974:	0f bd fe             	bsr    %esi,%edi
  801977:	83 f7 1f             	xor    $0x1f,%edi
  80197a:	75 40                	jne    8019bc <__udivdi3+0x9c>
  80197c:	39 ce                	cmp    %ecx,%esi
  80197e:	72 0a                	jb     80198a <__udivdi3+0x6a>
  801980:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801984:	0f 87 9e 00 00 00    	ja     801a28 <__udivdi3+0x108>
  80198a:	b8 01 00 00 00       	mov    $0x1,%eax
  80198f:	89 fa                	mov    %edi,%edx
  801991:	83 c4 1c             	add    $0x1c,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    
  801999:	8d 76 00             	lea    0x0(%esi),%esi
  80199c:	31 ff                	xor    %edi,%edi
  80199e:	31 c0                	xor    %eax,%eax
  8019a0:	89 fa                	mov    %edi,%edx
  8019a2:	83 c4 1c             	add    $0x1c,%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
  8019aa:	66 90                	xchg   %ax,%ax
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	f7 f7                	div    %edi
  8019b0:	31 ff                	xor    %edi,%edi
  8019b2:	89 fa                	mov    %edi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019c1:	89 eb                	mov    %ebp,%ebx
  8019c3:	29 fb                	sub    %edi,%ebx
  8019c5:	89 f9                	mov    %edi,%ecx
  8019c7:	d3 e6                	shl    %cl,%esi
  8019c9:	89 c5                	mov    %eax,%ebp
  8019cb:	88 d9                	mov    %bl,%cl
  8019cd:	d3 ed                	shr    %cl,%ebp
  8019cf:	89 e9                	mov    %ebp,%ecx
  8019d1:	09 f1                	or     %esi,%ecx
  8019d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d7:	89 f9                	mov    %edi,%ecx
  8019d9:	d3 e0                	shl    %cl,%eax
  8019db:	89 c5                	mov    %eax,%ebp
  8019dd:	89 d6                	mov    %edx,%esi
  8019df:	88 d9                	mov    %bl,%cl
  8019e1:	d3 ee                	shr    %cl,%esi
  8019e3:	89 f9                	mov    %edi,%ecx
  8019e5:	d3 e2                	shl    %cl,%edx
  8019e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 e8                	shr    %cl,%eax
  8019ef:	09 c2                	or     %eax,%edx
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	89 f2                	mov    %esi,%edx
  8019f5:	f7 74 24 0c          	divl   0xc(%esp)
  8019f9:	89 d6                	mov    %edx,%esi
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	f7 e5                	mul    %ebp
  8019ff:	39 d6                	cmp    %edx,%esi
  801a01:	72 19                	jb     801a1c <__udivdi3+0xfc>
  801a03:	74 0b                	je     801a10 <__udivdi3+0xf0>
  801a05:	89 d8                	mov    %ebx,%eax
  801a07:	31 ff                	xor    %edi,%edi
  801a09:	e9 58 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a0e:	66 90                	xchg   %ax,%ax
  801a10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a14:	89 f9                	mov    %edi,%ecx
  801a16:	d3 e2                	shl    %cl,%edx
  801a18:	39 c2                	cmp    %eax,%edx
  801a1a:	73 e9                	jae    801a05 <__udivdi3+0xe5>
  801a1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a1f:	31 ff                	xor    %edi,%edi
  801a21:	e9 40 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a26:	66 90                	xchg   %ax,%ax
  801a28:	31 c0                	xor    %eax,%eax
  801a2a:	e9 37 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a2f:	90                   	nop

00801a30 <__umoddi3>:
  801a30:	55                   	push   %ebp
  801a31:	57                   	push   %edi
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 1c             	sub    $0x1c,%esp
  801a37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a4f:	89 f3                	mov    %esi,%ebx
  801a51:	89 fa                	mov    %edi,%edx
  801a53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a57:	89 34 24             	mov    %esi,(%esp)
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	75 1a                	jne    801a78 <__umoddi3+0x48>
  801a5e:	39 f7                	cmp    %esi,%edi
  801a60:	0f 86 a2 00 00 00    	jbe    801b08 <__umoddi3+0xd8>
  801a66:	89 c8                	mov    %ecx,%eax
  801a68:	89 f2                	mov    %esi,%edx
  801a6a:	f7 f7                	div    %edi
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	31 d2                	xor    %edx,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	39 f0                	cmp    %esi,%eax
  801a7a:	0f 87 ac 00 00 00    	ja     801b2c <__umoddi3+0xfc>
  801a80:	0f bd e8             	bsr    %eax,%ebp
  801a83:	83 f5 1f             	xor    $0x1f,%ebp
  801a86:	0f 84 ac 00 00 00    	je     801b38 <__umoddi3+0x108>
  801a8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a91:	29 ef                	sub    %ebp,%edi
  801a93:	89 fe                	mov    %edi,%esi
  801a95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a99:	89 e9                	mov    %ebp,%ecx
  801a9b:	d3 e0                	shl    %cl,%eax
  801a9d:	89 d7                	mov    %edx,%edi
  801a9f:	89 f1                	mov    %esi,%ecx
  801aa1:	d3 ef                	shr    %cl,%edi
  801aa3:	09 c7                	or     %eax,%edi
  801aa5:	89 e9                	mov    %ebp,%ecx
  801aa7:	d3 e2                	shl    %cl,%edx
  801aa9:	89 14 24             	mov    %edx,(%esp)
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	d3 e0                	shl    %cl,%eax
  801ab0:	89 c2                	mov    %eax,%edx
  801ab2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab6:	d3 e0                	shl    %cl,%eax
  801ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac0:	89 f1                	mov    %esi,%ecx
  801ac2:	d3 e8                	shr    %cl,%eax
  801ac4:	09 d0                	or     %edx,%eax
  801ac6:	d3 eb                	shr    %cl,%ebx
  801ac8:	89 da                	mov    %ebx,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d3                	mov    %edx,%ebx
  801ace:	f7 24 24             	mull   (%esp)
  801ad1:	89 c6                	mov    %eax,%esi
  801ad3:	89 d1                	mov    %edx,%ecx
  801ad5:	39 d3                	cmp    %edx,%ebx
  801ad7:	0f 82 87 00 00 00    	jb     801b64 <__umoddi3+0x134>
  801add:	0f 84 91 00 00 00    	je     801b74 <__umoddi3+0x144>
  801ae3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ae7:	29 f2                	sub    %esi,%edx
  801ae9:	19 cb                	sbb    %ecx,%ebx
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801af1:	d3 e0                	shl    %cl,%eax
  801af3:	89 e9                	mov    %ebp,%ecx
  801af5:	d3 ea                	shr    %cl,%edx
  801af7:	09 d0                	or     %edx,%eax
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 eb                	shr    %cl,%ebx
  801afd:	89 da                	mov    %ebx,%edx
  801aff:	83 c4 1c             	add    $0x1c,%esp
  801b02:	5b                   	pop    %ebx
  801b03:	5e                   	pop    %esi
  801b04:	5f                   	pop    %edi
  801b05:	5d                   	pop    %ebp
  801b06:	c3                   	ret    
  801b07:	90                   	nop
  801b08:	89 fd                	mov    %edi,%ebp
  801b0a:	85 ff                	test   %edi,%edi
  801b0c:	75 0b                	jne    801b19 <__umoddi3+0xe9>
  801b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b13:	31 d2                	xor    %edx,%edx
  801b15:	f7 f7                	div    %edi
  801b17:	89 c5                	mov    %eax,%ebp
  801b19:	89 f0                	mov    %esi,%eax
  801b1b:	31 d2                	xor    %edx,%edx
  801b1d:	f7 f5                	div    %ebp
  801b1f:	89 c8                	mov    %ecx,%eax
  801b21:	f7 f5                	div    %ebp
  801b23:	89 d0                	mov    %edx,%eax
  801b25:	e9 44 ff ff ff       	jmp    801a6e <__umoddi3+0x3e>
  801b2a:	66 90                	xchg   %ax,%ax
  801b2c:	89 c8                	mov    %ecx,%eax
  801b2e:	89 f2                	mov    %esi,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	3b 04 24             	cmp    (%esp),%eax
  801b3b:	72 06                	jb     801b43 <__umoddi3+0x113>
  801b3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b41:	77 0f                	ja     801b52 <__umoddi3+0x122>
  801b43:	89 f2                	mov    %esi,%edx
  801b45:	29 f9                	sub    %edi,%ecx
  801b47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b4b:	89 14 24             	mov    %edx,(%esp)
  801b4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b56:	8b 14 24             	mov    (%esp),%edx
  801b59:	83 c4 1c             	add    $0x1c,%esp
  801b5c:	5b                   	pop    %ebx
  801b5d:	5e                   	pop    %esi
  801b5e:	5f                   	pop    %edi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
  801b61:	8d 76 00             	lea    0x0(%esi),%esi
  801b64:	2b 04 24             	sub    (%esp),%eax
  801b67:	19 fa                	sbb    %edi,%edx
  801b69:	89 d1                	mov    %edx,%ecx
  801b6b:	89 c6                	mov    %eax,%esi
  801b6d:	e9 71 ff ff ff       	jmp    801ae3 <__umoddi3+0xb3>
  801b72:	66 90                	xchg   %ax,%ax
  801b74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b78:	72 ea                	jb     801b64 <__umoddi3+0x134>
  801b7a:	89 d9                	mov    %ebx,%ecx
  801b7c:	e9 62 ff ff ff       	jmp    801ae3 <__umoddi3+0xb3>
