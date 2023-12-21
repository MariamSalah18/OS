
obj/user/tst_syscalls_2_slave2:     file format elf32-i386


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
  800031:	e8 33 00 00 00       	call   800069 <libmain>
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
	//[2] Invalid Range (Above USER_LIMIT)
	sys_allocate_user_mem(USER_LIMIT,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	68 00 00 80 ef       	push   $0xef800000
  800048:	e8 80 18 00 00       	call   8018cd <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 b0 16 00 00       	call   801705 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 a0 1b 80 00       	push   $0x801ba0
  80005d:	6a 0a                	push   $0xa
  80005f:	68 22 1c 80 00       	push   $0x801c22
  800064:	e8 2e 01 00 00       	call   800197 <_panic>

00800069 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006f:	e8 53 15 00 00       	call   8015c7 <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	01 c0                	add    %eax,%eax
  80007e:	01 d0                	add    %edx,%eax
  800080:	c1 e0 06             	shl    $0x6,%eax
  800083:	29 d0                	sub    %edx,%eax
  800085:	c1 e0 03             	shl    $0x3,%eax
  800088:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800092:	a1 20 30 80 00       	mov    0x803020,%eax
  800097:	8a 40 68             	mov    0x68(%eax),%al
  80009a:	84 c0                	test   %al,%al
  80009c:	74 0d                	je     8000ab <libmain+0x42>
		binaryname = myEnv->prog_name;
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	83 c0 68             	add    $0x68,%eax
  8000a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000af:	7e 0a                	jle    8000bb <libmain+0x52>
		binaryname = argv[0];
  8000b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b4:	8b 00                	mov    (%eax),%eax
  8000b6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	ff 75 0c             	pushl  0xc(%ebp)
  8000c1:	ff 75 08             	pushl  0x8(%ebp)
  8000c4:	e8 6f ff ff ff       	call   800038 <_main>
  8000c9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000cc:	e8 03 13 00 00       	call   8013d4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 58 1c 80 00       	push   $0x801c58
  8000d9:	e8 76 03 00 00       	call   800454 <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e6:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  8000ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f1:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	52                   	push   %edx
  8000fb:	50                   	push   %eax
  8000fc:	68 80 1c 80 00       	push   $0x801c80
  800101:	e8 4e 03 00 00       	call   800454 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800109:	a1 20 30 80 00       	mov    0x803020,%eax
  80010e:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800114:	a1 20 30 80 00       	mov    0x803020,%eax
  800119:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  80011f:	a1 20 30 80 00       	mov    0x803020,%eax
  800124:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80012a:	51                   	push   %ecx
  80012b:	52                   	push   %edx
  80012c:	50                   	push   %eax
  80012d:	68 a8 1c 80 00       	push   $0x801ca8
  800132:	e8 1d 03 00 00       	call   800454 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80013a:	a1 20 30 80 00       	mov    0x803020,%eax
  80013f:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	50                   	push   %eax
  800149:	68 00 1d 80 00       	push   $0x801d00
  80014e:	e8 01 03 00 00       	call   800454 <cprintf>
  800153:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	68 58 1c 80 00       	push   $0x801c58
  80015e:	e8 f1 02 00 00       	call   800454 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800166:	e8 83 12 00 00       	call   8013ee <sys_enable_interrupt>

	// exit gracefully
	exit();
  80016b:	e8 19 00 00 00       	call   800189 <exit>
}
  800170:	90                   	nop
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	6a 00                	push   $0x0
  80017e:	e8 10 14 00 00       	call   801593 <sys_destroy_env>
  800183:	83 c4 10             	add    $0x10,%esp
}
  800186:	90                   	nop
  800187:	c9                   	leave  
  800188:	c3                   	ret    

00800189 <exit>:

void
exit(void)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018f:	e8 65 14 00 00       	call   8015f9 <sys_exit_env>
}
  800194:	90                   	nop
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80019d:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a0:	83 c0 04             	add    $0x4,%eax
  8001a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001a6:	a1 18 31 80 00       	mov    0x803118,%eax
  8001ab:	85 c0                	test   %eax,%eax
  8001ad:	74 16                	je     8001c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001af:	a1 18 31 80 00       	mov    0x803118,%eax
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	50                   	push   %eax
  8001b8:	68 14 1d 80 00       	push   $0x801d14
  8001bd:	e8 92 02 00 00       	call   800454 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001c5:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ca:	ff 75 0c             	pushl  0xc(%ebp)
  8001cd:	ff 75 08             	pushl  0x8(%ebp)
  8001d0:	50                   	push   %eax
  8001d1:	68 19 1d 80 00       	push   $0x801d19
  8001d6:	e8 79 02 00 00       	call   800454 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e7:	50                   	push   %eax
  8001e8:	e8 fc 01 00 00       	call   8003e9 <vcprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	6a 00                	push   $0x0
  8001f5:	68 35 1d 80 00       	push   $0x801d35
  8001fa:	e8 ea 01 00 00       	call   8003e9 <vcprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800202:	e8 82 ff ff ff       	call   800189 <exit>

	// should not return here
	while (1) ;
  800207:	eb fe                	jmp    800207 <_panic+0x70>

00800209 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021d:	39 c2                	cmp    %eax,%edx
  80021f:	74 14                	je     800235 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800221:	83 ec 04             	sub    $0x4,%esp
  800224:	68 38 1d 80 00       	push   $0x801d38
  800229:	6a 26                	push   $0x26
  80022b:	68 84 1d 80 00       	push   $0x801d84
  800230:	e8 62 ff ff ff       	call   800197 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80023c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800243:	e9 c5 00 00 00       	jmp    80030d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80024b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	01 d0                	add    %edx,%eax
  800257:	8b 00                	mov    (%eax),%eax
  800259:	85 c0                	test   %eax,%eax
  80025b:	75 08                	jne    800265 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800260:	e9 a5 00 00 00       	jmp    80030a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800265:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80026c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800273:	eb 69                	jmp    8002de <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800280:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800283:	89 d0                	mov    %edx,%eax
  800285:	01 c0                	add    %eax,%eax
  800287:	01 d0                	add    %edx,%eax
  800289:	c1 e0 03             	shl    $0x3,%eax
  80028c:	01 c8                	add    %ecx,%eax
  80028e:	8a 40 04             	mov    0x4(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	75 46                	jne    8002db <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002a3:	89 d0                	mov    %edx,%eax
  8002a5:	01 c0                	add    %eax,%eax
  8002a7:	01 d0                	add    %edx,%eax
  8002a9:	c1 e0 03             	shl    $0x3,%eax
  8002ac:	01 c8                	add    %ecx,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	01 c8                	add    %ecx,%eax
  8002cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	75 09                	jne    8002db <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002d9:	eb 15                	jmp    8002f0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002db:	ff 45 e8             	incl   -0x18(%ebp)
  8002de:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e3:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8002e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ec:	39 c2                	cmp    %eax,%edx
  8002ee:	77 85                	ja     800275 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002f4:	75 14                	jne    80030a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 90 1d 80 00       	push   $0x801d90
  8002fe:	6a 3a                	push   $0x3a
  800300:	68 84 1d 80 00       	push   $0x801d84
  800305:	e8 8d fe ff ff       	call   800197 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80030a:	ff 45 f0             	incl   -0x10(%ebp)
  80030d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800310:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800313:	0f 8c 2f ff ff ff    	jl     800248 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800319:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800320:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800327:	eb 26                	jmp    80034f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  800334:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800337:	89 d0                	mov    %edx,%eax
  800339:	01 c0                	add    %eax,%eax
  80033b:	01 d0                	add    %edx,%eax
  80033d:	c1 e0 03             	shl    $0x3,%eax
  800340:	01 c8                	add    %ecx,%eax
  800342:	8a 40 04             	mov    0x4(%eax),%al
  800345:	3c 01                	cmp    $0x1,%al
  800347:	75 03                	jne    80034c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800349:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034c:	ff 45 e0             	incl   -0x20(%ebp)
  80034f:	a1 20 30 80 00       	mov    0x803020,%eax
  800354:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  80035a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035d:	39 c2                	cmp    %eax,%edx
  80035f:	77 c8                	ja     800329 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800364:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800367:	74 14                	je     80037d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 e4 1d 80 00       	push   $0x801de4
  800371:	6a 44                	push   $0x44
  800373:	68 84 1d 80 00       	push   $0x801d84
  800378:	e8 1a fe ff ff       	call   800197 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80037d:	90                   	nop
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800386:	8b 45 0c             	mov    0xc(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 48 01             	lea    0x1(%eax),%ecx
  80038e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800391:	89 0a                	mov    %ecx,(%edx)
  800393:	8b 55 08             	mov    0x8(%ebp),%edx
  800396:	88 d1                	mov    %dl,%cl
  800398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	75 2c                	jne    8003d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ab:	a0 24 30 80 00       	mov    0x803024,%al
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b6:	8b 12                	mov    (%edx),%edx
  8003b8:	89 d1                	mov    %edx,%ecx
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	83 c2 08             	add    $0x8,%edx
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	50                   	push   %eax
  8003c4:	51                   	push   %ecx
  8003c5:	52                   	push   %edx
  8003c6:	e8 b0 0e 00 00       	call   80127b <sys_cputs>
  8003cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003da:	8b 40 04             	mov    0x4(%eax),%eax
  8003dd:	8d 50 01             	lea    0x1(%eax),%edx
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f9:	00 00 00 
	b.cnt = 0;
  8003fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800403:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800406:	ff 75 0c             	pushl  0xc(%ebp)
  800409:	ff 75 08             	pushl  0x8(%ebp)
  80040c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800412:	50                   	push   %eax
  800413:	68 80 03 80 00       	push   $0x800380
  800418:	e8 11 02 00 00       	call   80062e <vprintfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800420:	a0 24 30 80 00       	mov    0x803024,%al
  800425:	0f b6 c0             	movzbl %al,%eax
  800428:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	50                   	push   %eax
  800432:	52                   	push   %edx
  800433:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800439:	83 c0 08             	add    $0x8,%eax
  80043c:	50                   	push   %eax
  80043d:	e8 39 0e 00 00       	call   80127b <sys_cputs>
  800442:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800445:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80044c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <cprintf>:

int cprintf(const char *fmt, ...) {
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80045a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800461:	8d 45 0c             	lea    0xc(%ebp),%eax
  800464:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 f4             	pushl  -0xc(%ebp)
  800470:	50                   	push   %eax
  800471:	e8 73 ff ff ff       	call   8003e9 <vcprintf>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800487:	e8 48 0f 00 00       	call   8013d4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 f4             	pushl  -0xc(%ebp)
  80049b:	50                   	push   %eax
  80049c:	e8 48 ff ff ff       	call   8003e9 <vcprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004a7:	e8 42 0f 00 00       	call   8013ee <sys_enable_interrupt>
	return cnt;
  8004ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 14             	sub    $0x14,%esp
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cf:	77 55                	ja     800526 <printnum+0x75>
  8004d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d4:	72 05                	jb     8004db <printnum+0x2a>
  8004d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d9:	77 4b                	ja     800526 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e9:	52                   	push   %edx
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f1:	e8 2a 14 00 00       	call   801920 <__udivdi3>
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	ff 75 20             	pushl  0x20(%ebp)
  8004ff:	53                   	push   %ebx
  800500:	ff 75 18             	pushl  0x18(%ebp)
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	ff 75 08             	pushl  0x8(%ebp)
  80050b:	e8 a1 ff ff ff       	call   8004b1 <printnum>
  800510:	83 c4 20             	add    $0x20,%esp
  800513:	eb 1a                	jmp    80052f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 20             	pushl  0x20(%ebp)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	ff d0                	call   *%eax
  800523:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800526:	ff 4d 1c             	decl   0x1c(%ebp)
  800529:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052d:	7f e6                	jg     800515 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800532:	bb 00 00 00 00       	mov    $0x0,%ebx
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053d:	53                   	push   %ebx
  80053e:	51                   	push   %ecx
  80053f:	52                   	push   %edx
  800540:	50                   	push   %eax
  800541:	e8 ea 14 00 00       	call   801a30 <__umoddi3>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	05 54 20 80 00       	add    $0x802054,%eax
  80054e:	8a 00                	mov    (%eax),%al
  800550:	0f be c0             	movsbl %al,%eax
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	ff 75 0c             	pushl  0xc(%ebp)
  800559:	50                   	push   %eax
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	ff d0                	call   *%eax
  80055f:	83 c4 10             	add    $0x10,%esp
}
  800562:	90                   	nop
  800563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800566:	c9                   	leave  
  800567:	c3                   	ret    

00800568 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80056b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80056f:	7e 1c                	jle    80058d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	8d 50 08             	lea    0x8(%eax),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	89 10                	mov    %edx,(%eax)
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	83 e8 08             	sub    $0x8,%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	eb 40                	jmp    8005cd <getuint+0x65>
	else if (lflag)
  80058d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800591:	74 1e                	je     8005b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	8d 50 04             	lea    0x4(%eax),%edx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 10                	mov    %edx,(%eax)
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	83 e8 04             	sub    $0x4,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	eb 1c                	jmp    8005cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	8d 50 04             	lea    0x4(%eax),%edx
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	89 10                	mov    %edx,(%eax)
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	83 e8 04             	sub    $0x4,%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d6:	7e 1c                	jle    8005f4 <getint+0x25>
		return va_arg(*ap, long long);
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 50 08             	lea    0x8(%eax),%edx
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	89 10                	mov    %edx,(%eax)
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	83 e8 08             	sub    $0x8,%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	eb 38                	jmp    80062c <getint+0x5d>
	else if (lflag)
  8005f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f8:	74 1a                	je     800614 <getint+0x45>
		return va_arg(*ap, long);
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	8d 50 04             	lea    0x4(%eax),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	89 10                	mov    %edx,(%eax)
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	83 e8 04             	sub    $0x4,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	99                   	cltd   
  800612:	eb 18                	jmp    80062c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	8d 50 04             	lea    0x4(%eax),%edx
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 10                	mov    %edx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	99                   	cltd   
}
  80062c:	5d                   	pop    %ebp
  80062d:	c3                   	ret    

0080062e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	56                   	push   %esi
  800632:	53                   	push   %ebx
  800633:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	eb 17                	jmp    80064f <vprintfmt+0x21>
			if (ch == '\0')
  800638:	85 db                	test   %ebx,%ebx
  80063a:	0f 84 af 03 00 00    	je     8009ef <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	53                   	push   %ebx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	ff d0                	call   *%eax
  80064c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	8b 45 10             	mov    0x10(%ebp),%eax
  800652:	8d 50 01             	lea    0x1(%eax),%edx
  800655:	89 55 10             	mov    %edx,0x10(%ebp)
  800658:	8a 00                	mov    (%eax),%al
  80065a:	0f b6 d8             	movzbl %al,%ebx
  80065d:	83 fb 25             	cmp    $0x25,%ebx
  800660:	75 d6                	jne    800638 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800662:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800666:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80066d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800674:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80067b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	8d 50 01             	lea    0x1(%eax),%edx
  800688:	89 55 10             	mov    %edx,0x10(%ebp)
  80068b:	8a 00                	mov    (%eax),%al
  80068d:	0f b6 d8             	movzbl %al,%ebx
  800690:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800693:	83 f8 55             	cmp    $0x55,%eax
  800696:	0f 87 2b 03 00 00    	ja     8009c7 <vprintfmt+0x399>
  80069c:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  8006a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a9:	eb d7                	jmp    800682 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d1                	jmp    800682 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bb:	89 d0                	mov    %edx,%eax
  8006bd:	c1 e0 02             	shl    $0x2,%eax
  8006c0:	01 d0                	add    %edx,%eax
  8006c2:	01 c0                	add    %eax,%eax
  8006c4:	01 d8                	add    %ebx,%eax
  8006c6:	83 e8 30             	sub    $0x30,%eax
  8006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cf:	8a 00                	mov    (%eax),%al
  8006d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d7:	7e 3e                	jle    800717 <vprintfmt+0xe9>
  8006d9:	83 fb 39             	cmp    $0x39,%ebx
  8006dc:	7f 39                	jg     800717 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e1:	eb d5                	jmp    8006b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	83 c0 04             	add    $0x4,%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 e8 04             	sub    $0x4,%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f7:	eb 1f                	jmp    800718 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fd:	79 83                	jns    800682 <vprintfmt+0x54>
				width = 0;
  8006ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800706:	e9 77 ff ff ff       	jmp    800682 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80070b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800712:	e9 6b ff ff ff       	jmp    800682 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800717:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	0f 89 60 ff ff ff    	jns    800682 <vprintfmt+0x54>
				width = precision, precision = -1;
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80072f:	e9 4e ff ff ff       	jmp    800682 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800734:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800737:	e9 46 ff ff ff       	jmp    800682 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	83 c0 04             	add    $0x4,%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	83 e8 04             	sub    $0x4,%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	50                   	push   %eax
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
			break;
  80075c:	e9 89 02 00 00       	jmp    8009ea <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	83 c0 04             	add    $0x4,%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800772:	85 db                	test   %ebx,%ebx
  800774:	79 02                	jns    800778 <vprintfmt+0x14a>
				err = -err;
  800776:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800778:	83 fb 64             	cmp    $0x64,%ebx
  80077b:	7f 0b                	jg     800788 <vprintfmt+0x15a>
  80077d:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  800784:	85 f6                	test   %esi,%esi
  800786:	75 19                	jne    8007a1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800788:	53                   	push   %ebx
  800789:	68 65 20 80 00       	push   $0x802065
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	ff 75 08             	pushl  0x8(%ebp)
  800794:	e8 5e 02 00 00       	call   8009f7 <printfmt>
  800799:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80079c:	e9 49 02 00 00       	jmp    8009ea <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a1:	56                   	push   %esi
  8007a2:	68 6e 20 80 00       	push   $0x80206e
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	ff 75 08             	pushl  0x8(%ebp)
  8007ad:	e8 45 02 00 00       	call   8009f7 <printfmt>
  8007b2:	83 c4 10             	add    $0x10,%esp
			break;
  8007b5:	e9 30 02 00 00       	jmp    8009ea <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 30                	mov    (%eax),%esi
  8007cb:	85 f6                	test   %esi,%esi
  8007cd:	75 05                	jne    8007d4 <vprintfmt+0x1a6>
				p = "(null)";
  8007cf:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  8007d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d8:	7e 6d                	jle    800847 <vprintfmt+0x219>
  8007da:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007de:	74 67                	je     800847 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	50                   	push   %eax
  8007e7:	56                   	push   %esi
  8007e8:	e8 0c 03 00 00       	call   800af9 <strnlen>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f3:	eb 16                	jmp    80080b <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007f5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	50                   	push   %eax
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800808:	ff 4d e4             	decl   -0x1c(%ebp)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	7f e4                	jg     8007f5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800811:	eb 34                	jmp    800847 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800813:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800817:	74 1c                	je     800835 <vprintfmt+0x207>
  800819:	83 fb 1f             	cmp    $0x1f,%ebx
  80081c:	7e 05                	jle    800823 <vprintfmt+0x1f5>
  80081e:	83 fb 7e             	cmp    $0x7e,%ebx
  800821:	7e 12                	jle    800835 <vprintfmt+0x207>
					putch('?', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	6a 3f                	push   $0x3f
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	eb 0f                	jmp    800844 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	53                   	push   %ebx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800844:	ff 4d e4             	decl   -0x1c(%ebp)
  800847:	89 f0                	mov    %esi,%eax
  800849:	8d 70 01             	lea    0x1(%eax),%esi
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f be d8             	movsbl %al,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	74 24                	je     800879 <vprintfmt+0x24b>
  800855:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800859:	78 b8                	js     800813 <vprintfmt+0x1e5>
  80085b:	ff 4d e0             	decl   -0x20(%ebp)
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	79 af                	jns    800813 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800864:	eb 13                	jmp    800879 <vprintfmt+0x24b>
				putch(' ', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 20                	push   $0x20
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087d:	7f e7                	jg     800866 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80087f:	e9 66 01 00 00       	jmp    8009ea <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 e8             	pushl  -0x18(%ebp)
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
  80088d:	50                   	push   %eax
  80088e:	e8 3c fd ff ff       	call   8005cf <getint>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	85 d2                	test   %edx,%edx
  8008a4:	79 23                	jns    8008c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	6a 2d                	push   $0x2d
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bc:	f7 d8                	neg    %eax
  8008be:	83 d2 00             	adc    $0x0,%edx
  8008c1:	f7 da                	neg    %edx
  8008c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d0:	e9 bc 00 00 00       	jmp    800991 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	e8 84 fc ff ff       	call   800568 <getuint>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f4:	e9 98 00 00 00       	jmp    800991 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	6a 58                	push   $0x58
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	6a 58                	push   $0x58
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	6a 58                	push   $0x58
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			break;
  800929:	e9 bc 00 00 00       	jmp    8009ea <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 30                	push   $0x30
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	6a 78                	push   $0x78
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	83 c0 04             	add    $0x4,%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800969:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800970:	eb 1f                	jmp    800991 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 e8             	pushl  -0x18(%ebp)
  800978:	8d 45 14             	lea    0x14(%ebp),%eax
  80097b:	50                   	push   %eax
  80097c:	e8 e7 fb ff ff       	call   800568 <getuint>
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800987:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80098a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800991:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800998:	83 ec 04             	sub    $0x4,%esp
  80099b:	52                   	push   %edx
  80099c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a6:	ff 75 0c             	pushl  0xc(%ebp)
  8009a9:	ff 75 08             	pushl  0x8(%ebp)
  8009ac:	e8 00 fb ff ff       	call   8004b1 <printnum>
  8009b1:	83 c4 20             	add    $0x20,%esp
			break;
  8009b4:	eb 34                	jmp    8009ea <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			break;
  8009c5:	eb 23                	jmp    8009ea <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	6a 25                	push   $0x25
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d7:	ff 4d 10             	decl   0x10(%ebp)
  8009da:	eb 03                	jmp    8009df <vprintfmt+0x3b1>
  8009dc:	ff 4d 10             	decl   0x10(%ebp)
  8009df:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e2:	48                   	dec    %eax
  8009e3:	8a 00                	mov    (%eax),%al
  8009e5:	3c 25                	cmp    $0x25,%al
  8009e7:	75 f3                	jne    8009dc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009e9:	90                   	nop
		}
	}
  8009ea:	e9 47 fc ff ff       	jmp    800636 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ef:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f3:	5b                   	pop    %ebx
  8009f4:	5e                   	pop    %esi
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009fd:	8d 45 10             	lea    0x10(%ebp),%eax
  800a00:	83 c0 04             	add    $0x4,%eax
  800a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a06:	8b 45 10             	mov    0x10(%ebp),%eax
  800a09:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0c:	50                   	push   %eax
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	ff 75 08             	pushl  0x8(%ebp)
  800a13:	e8 16 fc ff ff       	call   80062e <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a1b:	90                   	nop
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a24:	8b 40 08             	mov    0x8(%eax),%eax
  800a27:	8d 50 01             	lea    0x1(%eax),%edx
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	8b 10                	mov    (%eax),%edx
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	8b 40 04             	mov    0x4(%eax),%eax
  800a3b:	39 c2                	cmp    %eax,%edx
  800a3d:	73 12                	jae    800a51 <sprintputch+0x33>
		*b->buf++ = ch;
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	8d 48 01             	lea    0x1(%eax),%ecx
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	89 0a                	mov    %ecx,(%edx)
  800a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4f:	88 10                	mov    %dl,(%eax)
}
  800a51:	90                   	nop
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	01 d0                	add    %edx,%eax
  800a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a79:	74 06                	je     800a81 <vsnprintf+0x2d>
  800a7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7f:	7f 07                	jg     800a88 <vsnprintf+0x34>
		return -E_INVAL;
  800a81:	b8 03 00 00 00       	mov    $0x3,%eax
  800a86:	eb 20                	jmp    800aa8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a88:	ff 75 14             	pushl  0x14(%ebp)
  800a8b:	ff 75 10             	pushl  0x10(%ebp)
  800a8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	68 1e 0a 80 00       	push   $0x800a1e
  800a97:	e8 92 fb ff ff       	call   80062e <vprintfmt>
  800a9c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab3:	83 c0 04             	add    $0x4,%eax
  800ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  800abc:	ff 75 f4             	pushl  -0xc(%ebp)
  800abf:	50                   	push   %eax
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	ff 75 08             	pushl  0x8(%ebp)
  800ac6:	e8 89 ff ff ff       	call   800a54 <vsnprintf>
  800acb:	83 c4 10             	add    $0x10,%esp
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800adc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae3:	eb 06                	jmp    800aeb <strlen+0x15>
		n++;
  800ae5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae8:	ff 45 08             	incl   0x8(%ebp)
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	84 c0                	test   %al,%al
  800af2:	75 f1                	jne    800ae5 <strlen+0xf>
		n++;
	return n;
  800af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b06:	eb 09                	jmp    800b11 <strnlen+0x18>
		n++;
  800b08:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0b:	ff 45 08             	incl   0x8(%ebp)
  800b0e:	ff 4d 0c             	decl   0xc(%ebp)
  800b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b15:	74 09                	je     800b20 <strnlen+0x27>
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	84 c0                	test   %al,%al
  800b1e:	75 e8                	jne    800b08 <strnlen+0xf>
		n++;
	return n;
  800b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b31:	90                   	nop
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8d 50 01             	lea    0x1(%eax),%edx
  800b38:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b41:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b44:	8a 12                	mov    (%edx),%dl
  800b46:	88 10                	mov    %dl,(%eax)
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	84 c0                	test   %al,%al
  800b4c:	75 e4                	jne    800b32 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b66:	eb 1f                	jmp    800b87 <strncpy+0x34>
		*dst++ = *src;
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8d 50 01             	lea    0x1(%eax),%edx
  800b6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b74:	8a 12                	mov    (%edx),%dl
  800b76:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8a 00                	mov    (%eax),%al
  800b7d:	84 c0                	test   %al,%al
  800b7f:	74 03                	je     800b84 <strncpy+0x31>
			src++;
  800b81:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b84:	ff 45 fc             	incl   -0x4(%ebp)
  800b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b8d:	72 d9                	jb     800b68 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba4:	74 30                	je     800bd6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba6:	eb 16                	jmp    800bbe <strlcpy+0x2a>
			*dst++ = *src++;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8d 50 01             	lea    0x1(%eax),%edx
  800bae:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bba:	8a 12                	mov    (%edx),%dl
  800bbc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bbe:	ff 4d 10             	decl   0x10(%ebp)
  800bc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc5:	74 09                	je     800bd0 <strlcpy+0x3c>
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	84 c0                	test   %al,%al
  800bce:	75 d8                	jne    800ba8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdc:	29 c2                	sub    %eax,%edx
  800bde:	89 d0                	mov    %edx,%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be5:	eb 06                	jmp    800bed <strcmp+0xb>
		p++, q++;
  800be7:	ff 45 08             	incl   0x8(%ebp)
  800bea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	84 c0                	test   %al,%al
  800bf4:	74 0e                	je     800c04 <strcmp+0x22>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 10                	mov    (%eax),%dl
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	38 c2                	cmp    %al,%dl
  800c02:	74 e3                	je     800be7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	0f b6 d0             	movzbl %al,%edx
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f b6 c0             	movzbl %al,%eax
  800c14:	29 c2                	sub    %eax,%edx
  800c16:	89 d0                	mov    %edx,%eax
}
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c1d:	eb 09                	jmp    800c28 <strncmp+0xe>
		n--, p++, q++;
  800c1f:	ff 4d 10             	decl   0x10(%ebp)
  800c22:	ff 45 08             	incl   0x8(%ebp)
  800c25:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2c:	74 17                	je     800c45 <strncmp+0x2b>
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	84 c0                	test   %al,%al
  800c35:	74 0e                	je     800c45 <strncmp+0x2b>
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8a 10                	mov    (%eax),%dl
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	38 c2                	cmp    %al,%dl
  800c43:	74 da                	je     800c1f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c49:	75 07                	jne    800c52 <strncmp+0x38>
		return 0;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	eb 14                	jmp    800c66 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f b6 d0             	movzbl %al,%edx
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	0f b6 c0             	movzbl %al,%eax
  800c62:	29 c2                	sub    %eax,%edx
  800c64:	89 d0                	mov    %edx,%eax
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 04             	sub    $0x4,%esp
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c74:	eb 12                	jmp    800c88 <strchr+0x20>
		if (*s == c)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7e:	75 05                	jne    800c85 <strchr+0x1d>
			return (char *) s;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	eb 11                	jmp    800c96 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c85:	ff 45 08             	incl   0x8(%ebp)
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	84 c0                	test   %al,%al
  800c8f:	75 e5                	jne    800c76 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca4:	eb 0d                	jmp    800cb3 <strfind+0x1b>
		if (*s == c)
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cae:	74 0e                	je     800cbe <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	75 ea                	jne    800ca6 <strfind+0xe>
  800cbc:	eb 01                	jmp    800cbf <strfind+0x27>
		if (*s == c)
			break;
  800cbe:	90                   	nop
	return (char *) s;
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd6:	eb 0e                	jmp    800ce6 <memset+0x22>
		*p++ = c;
  800cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdb:	8d 50 01             	lea    0x1(%eax),%edx
  800cde:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce6:	ff 4d f8             	decl   -0x8(%ebp)
  800ce9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ced:	79 e9                	jns    800cd8 <memset+0x14>
		*p++ = c;

	return v;
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d06:	eb 16                	jmp    800d1e <memcpy+0x2a>
		*d++ = *s++;
  800d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0b:	8d 50 01             	lea    0x1(%eax),%edx
  800d0e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d17:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d1a:	8a 12                	mov    (%edx),%dl
  800d1c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d24:	89 55 10             	mov    %edx,0x10(%ebp)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	75 dd                	jne    800d08 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d45:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d48:	73 50                	jae    800d9a <memmove+0x6a>
  800d4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	01 d0                	add    %edx,%eax
  800d52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d55:	76 43                	jbe    800d9a <memmove+0x6a>
		s += n;
  800d57:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d63:	eb 10                	jmp    800d75 <memmove+0x45>
			*--d = *--s;
  800d65:	ff 4d f8             	decl   -0x8(%ebp)
  800d68:	ff 4d fc             	decl   -0x4(%ebp)
  800d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d73:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	75 e3                	jne    800d65 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d82:	eb 23                	jmp    800da7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d93:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d96:	8a 12                	mov    (%edx),%dl
  800d98:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da0:	89 55 10             	mov    %edx,0x10(%ebp)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	75 dd                	jne    800d84 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dbe:	eb 2a                	jmp    800dea <memcmp+0x3e>
		if (*s1 != *s2)
  800dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 16                	je     800de4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
  800de2:	eb 18                	jmp    800dfc <memcmp+0x50>
		s1++, s2++;
  800de4:	ff 45 fc             	incl   -0x4(%ebp)
  800de7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df0:	89 55 10             	mov    %edx,0x10(%ebp)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	75 c9                	jne    800dc0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	01 d0                	add    %edx,%eax
  800e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e0f:	eb 15                	jmp    800e26 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	0f b6 d0             	movzbl %al,%edx
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	0f b6 c0             	movzbl %al,%eax
  800e1f:	39 c2                	cmp    %eax,%edx
  800e21:	74 0d                	je     800e30 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e2c:	72 e3                	jb     800e11 <memfind+0x13>
  800e2e:	eb 01                	jmp    800e31 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e30:	90                   	nop
	return (void *) s;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e43:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4a:	eb 03                	jmp    800e4f <strtol+0x19>
		s++;
  800e4c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3c 20                	cmp    $0x20,%al
  800e56:	74 f4                	je     800e4c <strtol+0x16>
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	3c 09                	cmp    $0x9,%al
  800e5f:	74 eb                	je     800e4c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3c 2b                	cmp    $0x2b,%al
  800e68:	75 05                	jne    800e6f <strtol+0x39>
		s++;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	eb 13                	jmp    800e82 <strtol+0x4c>
	else if (*s == '-')
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	3c 2d                	cmp    $0x2d,%al
  800e76:	75 0a                	jne    800e82 <strtol+0x4c>
		s++, neg = 1;
  800e78:	ff 45 08             	incl   0x8(%ebp)
  800e7b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e86:	74 06                	je     800e8e <strtol+0x58>
  800e88:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e8c:	75 20                	jne    800eae <strtol+0x78>
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	3c 30                	cmp    $0x30,%al
  800e95:	75 17                	jne    800eae <strtol+0x78>
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	40                   	inc    %eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 78                	cmp    $0x78,%al
  800e9f:	75 0d                	jne    800eae <strtol+0x78>
		s += 2, base = 16;
  800ea1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eac:	eb 28                	jmp    800ed6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb2:	75 15                	jne    800ec9 <strtol+0x93>
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3c 30                	cmp    $0x30,%al
  800ebb:	75 0c                	jne    800ec9 <strtol+0x93>
		s++, base = 8;
  800ebd:	ff 45 08             	incl   0x8(%ebp)
  800ec0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec7:	eb 0d                	jmp    800ed6 <strtol+0xa0>
	else if (base == 0)
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	75 07                	jne    800ed6 <strtol+0xa0>
		base = 10;
  800ecf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	3c 2f                	cmp    $0x2f,%al
  800edd:	7e 19                	jle    800ef8 <strtol+0xc2>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	3c 39                	cmp    $0x39,%al
  800ee6:	7f 10                	jg     800ef8 <strtol+0xc2>
			dig = *s - '0';
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f be c0             	movsbl %al,%eax
  800ef0:	83 e8 30             	sub    $0x30,%eax
  800ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef6:	eb 42                	jmp    800f3a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 60                	cmp    $0x60,%al
  800eff:	7e 19                	jle    800f1a <strtol+0xe4>
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 7a                	cmp    $0x7a,%al
  800f08:	7f 10                	jg     800f1a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	0f be c0             	movsbl %al,%eax
  800f12:	83 e8 57             	sub    $0x57,%eax
  800f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f18:	eb 20                	jmp    800f3a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 40                	cmp    $0x40,%al
  800f21:	7e 39                	jle    800f5c <strtol+0x126>
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 5a                	cmp    $0x5a,%al
  800f2a:	7f 30                	jg     800f5c <strtol+0x126>
			dig = *s - 'A' + 10;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f be c0             	movsbl %al,%eax
  800f34:	83 e8 37             	sub    $0x37,%eax
  800f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f40:	7d 19                	jge    800f5b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f42:	ff 45 08             	incl   0x8(%ebp)
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4c:	89 c2                	mov    %eax,%edx
  800f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f51:	01 d0                	add    %edx,%eax
  800f53:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f56:	e9 7b ff ff ff       	jmp    800ed6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f5b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f60:	74 08                	je     800f6a <strtol+0x134>
		*endptr = (char *) s;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f6e:	74 07                	je     800f77 <strtol+0x141>
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f73:	f7 d8                	neg    %eax
  800f75:	eb 03                	jmp    800f7a <strtol+0x144>
  800f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <ltostr>:

void
ltostr(long value, char *str)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f94:	79 13                	jns    800fa9 <ltostr+0x2d>
	{
		neg = 1;
  800f96:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb1:	99                   	cltd   
  800fb2:	f7 f9                	idiv   %ecx
  800fb4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	01 d0                	add    %edx,%eax
  800fc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fca:	83 c2 30             	add    $0x30,%edx
  800fcd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd7:	f7 e9                	imul   %ecx
  800fd9:	c1 fa 02             	sar    $0x2,%edx
  800fdc:	89 c8                	mov    %ecx,%eax
  800fde:	c1 f8 1f             	sar    $0x1f,%eax
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 d0                	mov    %edx,%eax
  800fe5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fe8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800feb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff0:	f7 e9                	imul   %ecx
  800ff2:	c1 fa 02             	sar    $0x2,%edx
  800ff5:	89 c8                	mov    %ecx,%eax
  800ff7:	c1 f8 1f             	sar    $0x1f,%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	c1 e0 02             	shl    $0x2,%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	01 c0                	add    %eax,%eax
  801005:	29 c1                	sub    %eax,%ecx
  801007:	89 ca                	mov    %ecx,%edx
  801009:	85 d2                	test   %edx,%edx
  80100b:	75 9c                	jne    800fa9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801017:	48                   	dec    %eax
  801018:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101f:	74 3d                	je     80105e <ltostr+0xe2>
		start = 1 ;
  801021:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801028:	eb 34                	jmp    80105e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	01 c2                	add    %eax,%edx
  80103f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 c8                	add    %ecx,%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	01 c2                	add    %eax,%edx
  801053:	8a 45 eb             	mov    -0x15(%ebp),%al
  801056:	88 02                	mov    %al,(%edx)
		start++ ;
  801058:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801061:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801064:	7c c4                	jl     80102a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801066:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	01 d0                	add    %edx,%eax
  80106e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801071:	90                   	nop
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107a:	ff 75 08             	pushl  0x8(%ebp)
  80107d:	e8 54 fa ff ff       	call   800ad6 <strlen>
  801082:	83 c4 04             	add    $0x4,%esp
  801085:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	e8 46 fa ff ff       	call   800ad6 <strlen>
  801090:	83 c4 04             	add    $0x4,%esp
  801093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a4:	eb 17                	jmp    8010bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 c2                	add    %eax,%edx
  8010ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	01 c8                	add    %ecx,%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ba:	ff 45 fc             	incl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c3:	7c e1                	jl     8010a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d3:	eb 1f                	jmp    8010f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8d 50 01             	lea    0x1(%eax),%edx
  8010db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	01 c2                	add    %eax,%edx
  8010e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 c8                	add    %ecx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f1:	ff 45 f8             	incl   -0x8(%ebp)
  8010f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fa:	7c d9                	jl     8010d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	c6 00 00             	movb   $0x0,(%eax)
}
  801107:	90                   	nop
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112d:	eb 0c                	jmp    80113b <strsplit+0x31>
			*string++ = 0;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 08             	mov    %edx,0x8(%ebp)
  801138:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	84 c0                	test   %al,%al
  801142:	74 18                	je     80115c <strsplit+0x52>
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	50                   	push   %eax
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	e8 13 fb ff ff       	call   800c68 <strchr>
  801155:	83 c4 08             	add    $0x8,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	75 d3                	jne    80112f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	84 c0                	test   %al,%al
  801163:	74 5a                	je     8011bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801165:	8b 45 14             	mov    0x14(%ebp),%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	83 f8 0f             	cmp    $0xf,%eax
  80116d:	75 07                	jne    801176 <strsplit+0x6c>
		{
			return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
  801174:	eb 66                	jmp    8011dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801176:	8b 45 14             	mov    0x14(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 14             	mov    0x14(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118a:	8b 45 10             	mov    0x10(%ebp),%eax
  80118d:	01 c2                	add    %eax,%edx
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801194:	eb 03                	jmp    801199 <strsplit+0x8f>
			string++;
  801196:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	84 c0                	test   %al,%al
  8011a0:	74 8b                	je     80112d <strsplit+0x23>
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f be c0             	movsbl %al,%eax
  8011aa:	50                   	push   %eax
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	e8 b5 fa ff ff       	call   800c68 <strchr>
  8011b3:	83 c4 08             	add    $0x8,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 dc                	je     801196 <strsplit+0x8c>
			string++;
	}
  8011ba:	e9 6e ff ff ff       	jmp    80112d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011eb:	eb 4c                	jmp    801239 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  8011ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 d0                	add    %edx,%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 40                	cmp    $0x40,%al
  8011f9:	7e 27                	jle    801222 <str2lower+0x44>
  8011fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 5a                	cmp    $0x5a,%al
  801207:	7f 19                	jg     801222 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801209:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	01 ca                	add    %ecx,%edx
  801219:	8a 12                	mov    (%edx),%dl
  80121b:	83 c2 20             	add    $0x20,%edx
  80121e:	88 10                	mov    %dl,(%eax)
  801220:	eb 14                	jmp    801236 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801222:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	01 c2                	add    %eax,%edx
  80122a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	01 c8                	add    %ecx,%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801236:	ff 45 fc             	incl   -0x4(%ebp)
  801239:	ff 75 0c             	pushl  0xc(%ebp)
  80123c:	e8 95 f8 ff ff       	call   800ad6 <strlen>
  801241:	83 c4 04             	add    $0x4,%esp
  801244:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801247:	7f a4                	jg     8011ed <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801262:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801265:	8b 7d 18             	mov    0x18(%ebp),%edi
  801268:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80126b:	cd 30                	int    $0x30
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801270:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801287:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	52                   	push   %edx
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	6a 00                	push   $0x0
  801299:	e8 b2 ff ff ff       	call   801250 <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 01                	push   $0x1
  8012b3:	e8 98 ff ff ff       	call   801250 <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	52                   	push   %edx
  8012cd:	50                   	push   %eax
  8012ce:	6a 05                	push   $0x5
  8012d0:	e8 7b ff ff ff       	call   801250 <syscall>
  8012d5:	83 c4 18             	add    $0x18,%esp
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012df:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	51                   	push   %ecx
  8012f1:	52                   	push   %edx
  8012f2:	50                   	push   %eax
  8012f3:	6a 06                	push   $0x6
  8012f5:	e8 56 ff ff ff       	call   801250 <syscall>
  8012fa:	83 c4 18             	add    $0x18,%esp
}
  8012fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	52                   	push   %edx
  801314:	50                   	push   %eax
  801315:	6a 07                	push   $0x7
  801317:	e8 34 ff ff ff       	call   801250 <syscall>
  80131c:	83 c4 18             	add    $0x18,%esp
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	ff 75 08             	pushl  0x8(%ebp)
  801330:	6a 08                	push   $0x8
  801332:	e8 19 ff ff ff       	call   801250 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 09                	push   $0x9
  80134b:	e8 00 ff ff ff       	call   801250 <syscall>
  801350:	83 c4 18             	add    $0x18,%esp
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 0a                	push   $0xa
  801364:	e8 e7 fe ff ff       	call   801250 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 0b                	push   $0xb
  80137d:	e8 ce fe ff ff       	call   801250 <syscall>
  801382:	83 c4 18             	add    $0x18,%esp
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 0c                	push   $0xc
  801396:	e8 b5 fe ff ff       	call   801250 <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	ff 75 08             	pushl  0x8(%ebp)
  8013ae:	6a 0d                	push   $0xd
  8013b0:	e8 9b fe ff ff       	call   801250 <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 0e                	push   $0xe
  8013c9:	e8 82 fe ff ff       	call   801250 <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	90                   	nop
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 11                	push   $0x11
  8013e3:	e8 68 fe ff ff       	call   801250 <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 12                	push   $0x12
  8013fd:	e8 4e fe ff ff       	call   801250 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	90                   	nop
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_cputc>:


void
sys_cputc(const char c)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801414:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	50                   	push   %eax
  801421:	6a 13                	push   $0x13
  801423:	e8 28 fe ff ff       	call   801250 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	90                   	nop
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 14                	push   $0x14
  80143d:	e8 0e fe ff ff       	call   801250 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	90                   	nop
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	50                   	push   %eax
  801458:	6a 15                	push   $0x15
  80145a:	e8 f1 fd ff ff       	call   801250 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	52                   	push   %edx
  801474:	50                   	push   %eax
  801475:	6a 18                	push   $0x18
  801477:	e8 d4 fd ff ff       	call   801250 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801484:	8b 55 0c             	mov    0xc(%ebp),%edx
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	52                   	push   %edx
  801491:	50                   	push   %eax
  801492:	6a 16                	push   $0x16
  801494:	e8 b7 fd ff ff       	call   801250 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	52                   	push   %edx
  8014af:	50                   	push   %eax
  8014b0:	6a 17                	push   $0x17
  8014b2:	e8 99 fd ff ff       	call   801250 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	90                   	nop
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	51                   	push   %ecx
  8014d6:	52                   	push   %edx
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	50                   	push   %eax
  8014db:	6a 19                	push   $0x19
  8014dd:	e8 6e fd ff ff       	call   801250 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 1a                	push   $0x1a
  8014fa:	e8 51 fd ff ff       	call   801250 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801507:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	51                   	push   %ecx
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 1b                	push   $0x1b
  801519:	e8 32 fd ff ff       	call   801250 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	6a 1c                	push   $0x1c
  801536:	e8 15 fd ff ff       	call   801250 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 1d                	push   $0x1d
  80154f:	e8 fc fc ff ff       	call   801250 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	6a 00                	push   $0x0
  801561:	ff 75 14             	pushl  0x14(%ebp)
  801564:	ff 75 10             	pushl  0x10(%ebp)
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	50                   	push   %eax
  80156b:	6a 1e                	push   $0x1e
  80156d:	e8 de fc ff ff       	call   801250 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	50                   	push   %eax
  801586:	6a 1f                	push   $0x1f
  801588:	e8 c3 fc ff ff       	call   801250 <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	90                   	nop
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	50                   	push   %eax
  8015a2:	6a 20                	push   $0x20
  8015a4:	e8 a7 fc ff ff       	call   801250 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 02                	push   $0x2
  8015bd:	e8 8e fc ff ff       	call   801250 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 03                	push   $0x3
  8015d6:	e8 75 fc ff ff       	call   801250 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 04                	push   $0x4
  8015ef:	e8 5c fc ff ff       	call   801250 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 21                	push   $0x21
  801608:	e8 43 fc ff ff       	call   801250 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801619:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161c:	8d 50 04             	lea    0x4(%eax),%edx
  80161f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	6a 22                	push   $0x22
  80162c:	e8 1f fc ff ff       	call   801250 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
	return result;
  801634:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801637:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163d:	89 01                	mov    %eax,(%ecx)
  80163f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	c9                   	leave  
  801646:	c2 04 00             	ret    $0x4

00801649 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	ff 75 10             	pushl  0x10(%ebp)
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	6a 10                	push   $0x10
  80165b:	e8 f0 fb ff ff       	call   801250 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
	return ;
  801663:	90                   	nop
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_rcr2>:
uint32 sys_rcr2()
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 23                	push   $0x23
  801675:	e8 d6 fb ff ff       	call   801250 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80168b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	50                   	push   %eax
  801698:	6a 24                	push   $0x24
  80169a:	e8 b1 fb ff ff       	call   801250 <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a2:	90                   	nop
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <rsttst>:
void rsttst()
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 26                	push   $0x26
  8016b4:	e8 97 fb ff ff       	call   801250 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bc:	90                   	nop
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8016ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d2:	52                   	push   %edx
  8016d3:	50                   	push   %eax
  8016d4:	ff 75 10             	pushl  0x10(%ebp)
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	6a 25                	push   $0x25
  8016df:	e8 6c fb ff ff       	call   801250 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e7:	90                   	nop
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <chktst>:
void chktst(uint32 n)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	ff 75 08             	pushl  0x8(%ebp)
  8016f8:	6a 27                	push   $0x27
  8016fa:	e8 51 fb ff ff       	call   801250 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801702:	90                   	nop
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <inctst>:

void inctst()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 28                	push   $0x28
  801714:	e8 37 fb ff ff       	call   801250 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
	return ;
  80171c:	90                   	nop
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <gettst>:
uint32 gettst()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 29                	push   $0x29
  80172e:	e8 1d fb ff ff       	call   801250 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 2a                	push   $0x2a
  80174a:	e8 01 fb ff ff       	call   801250 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
  801752:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801755:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801759:	75 07                	jne    801762 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80175b:	b8 01 00 00 00       	mov    $0x1,%eax
  801760:	eb 05                	jmp    801767 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 2a                	push   $0x2a
  80177b:	e8 d0 fa ff ff       	call   801250 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
  801783:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801786:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80178a:	75 07                	jne    801793 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80178c:	b8 01 00 00 00       	mov    $0x1,%eax
  801791:	eb 05                	jmp    801798 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 2a                	push   $0x2a
  8017ac:	e8 9f fa ff ff       	call   801250 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017bb:	75 07                	jne    8017c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c2:	eb 05                	jmp    8017c9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 2a                	push   $0x2a
  8017dd:	e8 6e fa ff ff       	call   801250 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
  8017e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ec:	75 07                	jne    8017f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f3:	eb 05                	jmp    8017fa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	6a 2b                	push   $0x2b
  80180c:	e8 3f fa ff ff       	call   801250 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
	return ;
  801814:	90                   	nop
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80181b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801821:	8b 55 0c             	mov    0xc(%ebp),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	6a 00                	push   $0x0
  801829:	53                   	push   %ebx
  80182a:	51                   	push   %ecx
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 2c                	push   $0x2c
  80182f:	e8 1c fa ff ff       	call   801250 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	6a 2d                	push   $0x2d
  80184f:	e8 fc f9 ff ff       	call   801250 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80185c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	6a 00                	push   $0x0
  801867:	51                   	push   %ecx
  801868:	ff 75 10             	pushl  0x10(%ebp)
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 2e                	push   $0x2e
  80186f:	e8 dc f9 ff ff       	call   801250 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 10             	pushl  0x10(%ebp)
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	ff 75 08             	pushl  0x8(%ebp)
  801889:	6a 0f                	push   $0xf
  80188b:	e8 c0 f9 ff ff       	call   801250 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
	return ;
  801893:	90                   	nop
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	50                   	push   %eax
  8018a5:	6a 2f                	push   $0x2f
  8018a7:	e8 a4 f9 ff ff       	call   801250 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp

}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 30                	push   $0x30
  8018c2:	e8 89 f9 ff ff       	call   801250 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	ff 75 08             	pushl  0x8(%ebp)
  8018dc:	6a 31                	push   $0x31
  8018de:	e8 6d f9 ff ff       	call   801250 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
	return;
  8018e6:	90                   	nop
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 32                	push   $0x32
  8018f8:	e8 53 f9 ff ff       	call   801250 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	50                   	push   %eax
  801911:	6a 33                	push   $0x33
  801913:	e8 38 f9 ff ff       	call   801250 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	90                   	nop
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    
  80191e:	66 90                	xchg   %ax,%ax

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
