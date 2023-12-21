
obj/user/tst_syscalls_1:     file format elf32-i386


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
  800031:	e8 8a 00 00 00       	call   8000c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct implementation of system calls
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 b9 16 00 00       	call   8016fc <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 a0 18 00 00       	call   8018ed <sys_sbrk>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ret != (void*)-1)
  800053:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  800057:	74 14                	je     80006d <_main+0x35>
		panic("tst system calls #1 failed: sys_sbrk is not handled correctly");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 e0 1b 80 00       	push   $0x801be0
  800061:	6a 0a                	push   $0xa
  800063:	68 1e 1c 80 00       	push   $0x801c1e
  800068:	e8 81 01 00 00       	call   8001ee <_panic>
	sys_allocate_user_mem(100,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	6a 64                	push   $0x64
  800074:	e8 ab 18 00 00       	call   801924 <sys_allocate_user_mem>
  800079:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(100, 10);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	6a 0a                	push   $0xa
  800081:	6a 64                	push   $0x64
  800083:	e8 80 18 00 00       	call   801908 <sys_free_user_mem>
  800088:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  80008b:	e8 e6 16 00 00       	call   801776 <gettst>
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800093:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800097:	74 14                	je     8000ad <_main+0x75>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 34 1c 80 00       	push   $0x801c34
  8000a1:	6a 0f                	push   $0xf
  8000a3:	68 1e 1c 80 00       	push   $0x801c1e
  8000a8:	e8 41 01 00 00       	call   8001ee <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 9c 1c 80 00       	push   $0x801c9c
  8000b5:	e8 f1 03 00 00       	call   8004ab <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
}
  8000bd:	90                   	nop
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c6:	e8 53 15 00 00       	call   80161e <sys_getenvindex>
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d1:	89 d0                	mov    %edx,%eax
  8000d3:	01 c0                	add    %eax,%eax
  8000d5:	01 d0                	add    %edx,%eax
  8000d7:	c1 e0 06             	shl    $0x6,%eax
  8000da:	29 d0                	sub    %edx,%eax
  8000dc:	c1 e0 03             	shl    $0x3,%eax
  8000df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ee:	8a 40 68             	mov    0x68(%eax),%al
  8000f1:	84 c0                	test   %al,%al
  8000f3:	74 0d                	je     800102 <libmain+0x42>
		binaryname = myEnv->prog_name;
  8000f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fa:	83 c0 68             	add    $0x68,%eax
  8000fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800106:	7e 0a                	jle    800112 <libmain+0x52>
		binaryname = argv[0];
  800108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010b:	8b 00                	mov    (%eax),%eax
  80010d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	ff 75 0c             	pushl  0xc(%ebp)
  800118:	ff 75 08             	pushl  0x8(%ebp)
  80011b:	e8 18 ff ff ff       	call   800038 <_main>
  800120:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800123:	e8 03 13 00 00       	call   80142b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 f4 1c 80 00       	push   $0x801cf4
  800130:	e8 76 03 00 00       	call   8004ab <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800138:	a1 20 30 80 00       	mov    0x803020,%eax
  80013d:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  800143:	a1 20 30 80 00       	mov    0x803020,%eax
  800148:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	52                   	push   %edx
  800152:	50                   	push   %eax
  800153:	68 1c 1d 80 00       	push   $0x801d1c
  800158:	e8 4e 03 00 00       	call   8004ab <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800160:	a1 20 30 80 00       	mov    0x803020,%eax
  800165:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  80016b:	a1 20 30 80 00       	mov    0x803020,%eax
  800170:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  800181:	51                   	push   %ecx
  800182:	52                   	push   %edx
  800183:	50                   	push   %eax
  800184:	68 44 1d 80 00       	push   $0x801d44
  800189:	e8 1d 03 00 00       	call   8004ab <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800191:	a1 20 30 80 00       	mov    0x803020,%eax
  800196:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	50                   	push   %eax
  8001a0:	68 9c 1d 80 00       	push   $0x801d9c
  8001a5:	e8 01 03 00 00       	call   8004ab <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 f4 1c 80 00       	push   $0x801cf4
  8001b5:	e8 f1 02 00 00       	call   8004ab <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001bd:	e8 83 12 00 00       	call   801445 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001c2:	e8 19 00 00 00       	call   8001e0 <exit>
}
  8001c7:	90                   	nop
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	e8 10 14 00 00       	call   8015ea <sys_destroy_env>
  8001da:	83 c4 10             	add    $0x10,%esp
}
  8001dd:	90                   	nop
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <exit>:

void
exit(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001e6:	e8 65 14 00 00       	call   801650 <sys_exit_env>
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8001f7:	83 c0 04             	add    $0x4,%eax
  8001fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001fd:	a1 18 31 80 00       	mov    0x803118,%eax
  800202:	85 c0                	test   %eax,%eax
  800204:	74 16                	je     80021c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800206:	a1 18 31 80 00       	mov    0x803118,%eax
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	50                   	push   %eax
  80020f:	68 b0 1d 80 00       	push   $0x801db0
  800214:	e8 92 02 00 00       	call   8004ab <cprintf>
  800219:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80021c:	a1 00 30 80 00       	mov    0x803000,%eax
  800221:	ff 75 0c             	pushl  0xc(%ebp)
  800224:	ff 75 08             	pushl  0x8(%ebp)
  800227:	50                   	push   %eax
  800228:	68 b5 1d 80 00       	push   $0x801db5
  80022d:	e8 79 02 00 00       	call   8004ab <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800235:	8b 45 10             	mov    0x10(%ebp),%eax
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	ff 75 f4             	pushl  -0xc(%ebp)
  80023e:	50                   	push   %eax
  80023f:	e8 fc 01 00 00       	call   800440 <vcprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	6a 00                	push   $0x0
  80024c:	68 d1 1d 80 00       	push   $0x801dd1
  800251:	e8 ea 01 00 00       	call   800440 <vcprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800259:	e8 82 ff ff ff       	call   8001e0 <exit>

	// should not return here
	while (1) ;
  80025e:	eb fe                	jmp    80025e <_panic+0x70>

00800260 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800266:	a1 20 30 80 00       	mov    0x803020,%eax
  80026b:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800271:	8b 45 0c             	mov    0xc(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 d4 1d 80 00       	push   $0x801dd4
  800280:	6a 26                	push   $0x26
  800282:	68 20 1e 80 00       	push   $0x801e20
  800287:	e8 62 ff ff ff       	call   8001ee <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80028c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800293:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80029a:	e9 c5 00 00 00       	jmp    800364 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80029f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	75 08                	jne    8002bc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002b4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002b7:	e9 a5 00 00 00       	jmp    800361 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ca:	eb 69                	jmp    800335 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002da:	89 d0                	mov    %edx,%eax
  8002dc:	01 c0                	add    %eax,%eax
  8002de:	01 d0                	add    %edx,%eax
  8002e0:	c1 e0 03             	shl    $0x3,%eax
  8002e3:	01 c8                	add    %ecx,%eax
  8002e5:	8a 40 04             	mov    0x4(%eax),%al
  8002e8:	84 c0                	test   %al,%al
  8002ea:	75 46                	jne    800332 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f1:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  8002f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002fa:	89 d0                	mov    %edx,%eax
  8002fc:	01 c0                	add    %eax,%eax
  8002fe:	01 d0                	add    %edx,%eax
  800300:	c1 e0 03             	shl    $0x3,%eax
  800303:	01 c8                	add    %ecx,%eax
  800305:	8b 00                	mov    (%eax),%eax
  800307:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80030a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80030d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800312:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800317:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 c8                	add    %ecx,%eax
  800323:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800325:	39 c2                	cmp    %eax,%edx
  800327:	75 09                	jne    800332 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800329:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800330:	eb 15                	jmp    800347 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800332:	ff 45 e8             	incl   -0x18(%ebp)
  800335:	a1 20 30 80 00       	mov    0x803020,%eax
  80033a:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	39 c2                	cmp    %eax,%edx
  800345:	77 85                	ja     8002cc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800347:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80034b:	75 14                	jne    800361 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 2c 1e 80 00       	push   $0x801e2c
  800355:	6a 3a                	push   $0x3a
  800357:	68 20 1e 80 00       	push   $0x801e20
  80035c:	e8 8d fe ff ff       	call   8001ee <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800361:	ff 45 f0             	incl   -0x10(%ebp)
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80036a:	0f 8c 2f ff ff ff    	jl     80029f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800370:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800377:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80037e:	eb 26                	jmp    8003a6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800380:	a1 20 30 80 00       	mov    0x803020,%eax
  800385:	8b 88 c4 05 00 00    	mov    0x5c4(%eax),%ecx
  80038b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80038e:	89 d0                	mov    %edx,%eax
  800390:	01 c0                	add    %eax,%eax
  800392:	01 d0                	add    %edx,%eax
  800394:	c1 e0 03             	shl    $0x3,%eax
  800397:	01 c8                	add    %ecx,%eax
  800399:	8a 40 04             	mov    0x4(%eax),%al
  80039c:	3c 01                	cmp    $0x1,%al
  80039e:	75 03                	jne    8003a3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	ff 45 e0             	incl   -0x20(%ebp)
  8003a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ab:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
  8003b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b4:	39 c2                	cmp    %eax,%edx
  8003b6:	77 c8                	ja     800380 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003be:	74 14                	je     8003d4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 80 1e 80 00       	push   $0x801e80
  8003c8:	6a 44                	push   $0x44
  8003ca:	68 20 1e 80 00       	push   $0x801e20
  8003cf:	e8 1a fe ff ff       	call   8001ee <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003d4:	90                   	nop
  8003d5:	c9                   	leave  
  8003d6:	c3                   	ret    

008003d7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8003e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e8:	89 0a                	mov    %ecx,(%edx)
  8003ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ed:	88 d1                	mov    %dl,%cl
  8003ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800400:	75 2c                	jne    80042e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800402:	a0 24 30 80 00       	mov    0x803024,%al
  800407:	0f b6 c0             	movzbl %al,%eax
  80040a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040d:	8b 12                	mov    (%edx),%edx
  80040f:	89 d1                	mov    %edx,%ecx
  800411:	8b 55 0c             	mov    0xc(%ebp),%edx
  800414:	83 c2 08             	add    $0x8,%edx
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	50                   	push   %eax
  80041b:	51                   	push   %ecx
  80041c:	52                   	push   %edx
  80041d:	e8 b0 0e 00 00       	call   8012d2 <sys_cputs>
  800422:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800425:	8b 45 0c             	mov    0xc(%ebp),%eax
  800428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80042e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800431:	8b 40 04             	mov    0x4(%eax),%eax
  800434:	8d 50 01             	lea    0x1(%eax),%edx
  800437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80043d:	90                   	nop
  80043e:	c9                   	leave  
  80043f:	c3                   	ret    

00800440 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800449:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800450:	00 00 00 
	b.cnt = 0;
  800453:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80045a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	68 d7 03 80 00       	push   $0x8003d7
  80046f:	e8 11 02 00 00       	call   800685 <vprintfmt>
  800474:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800477:	a0 24 30 80 00       	mov    0x803024,%al
  80047c:	0f b6 c0             	movzbl %al,%eax
  80047f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800485:	83 ec 04             	sub    $0x4,%esp
  800488:	50                   	push   %eax
  800489:	52                   	push   %edx
  80048a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800490:	83 c0 08             	add    $0x8,%eax
  800493:	50                   	push   %eax
  800494:	e8 39 0e 00 00       	call   8012d2 <sys_cputs>
  800499:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80049c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <cprintf>:

int cprintf(const char *fmt, ...) {
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004b1:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8004b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c7:	50                   	push   %eax
  8004c8:	e8 73 ff ff ff       	call   800440 <vcprintf>
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    

008004d8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004de:	e8 48 0f 00 00       	call   80142b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f2:	50                   	push   %eax
  8004f3:	e8 48 ff ff ff       	call   800440 <vcprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004fe:	e8 42 0f 00 00       	call   801445 <sys_enable_interrupt>
	return cnt;
  800503:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800506:	c9                   	leave  
  800507:	c3                   	ret    

00800508 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800508:	55                   	push   %ebp
  800509:	89 e5                	mov    %esp,%ebp
  80050b:	53                   	push   %ebx
  80050c:	83 ec 14             	sub    $0x14,%esp
  80050f:	8b 45 10             	mov    0x10(%ebp),%eax
  800512:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80051b:	8b 45 18             	mov    0x18(%ebp),%eax
  80051e:	ba 00 00 00 00       	mov    $0x0,%edx
  800523:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800526:	77 55                	ja     80057d <printnum+0x75>
  800528:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80052b:	72 05                	jb     800532 <printnum+0x2a>
  80052d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800530:	77 4b                	ja     80057d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800532:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800535:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800538:	8b 45 18             	mov    0x18(%ebp),%eax
  80053b:	ba 00 00 00 00       	mov    $0x0,%edx
  800540:	52                   	push   %edx
  800541:	50                   	push   %eax
  800542:	ff 75 f4             	pushl  -0xc(%ebp)
  800545:	ff 75 f0             	pushl  -0x10(%ebp)
  800548:	e8 2b 14 00 00       	call   801978 <__udivdi3>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	ff 75 20             	pushl  0x20(%ebp)
  800556:	53                   	push   %ebx
  800557:	ff 75 18             	pushl  0x18(%ebp)
  80055a:	52                   	push   %edx
  80055b:	50                   	push   %eax
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	ff 75 08             	pushl  0x8(%ebp)
  800562:	e8 a1 ff ff ff       	call   800508 <printnum>
  800567:	83 c4 20             	add    $0x20,%esp
  80056a:	eb 1a                	jmp    800586 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 20             	pushl  0x20(%ebp)
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	ff d0                	call   *%eax
  80057a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80057d:	ff 4d 1c             	decl   0x1c(%ebp)
  800580:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800584:	7f e6                	jg     80056c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800586:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800589:	bb 00 00 00 00       	mov    $0x0,%ebx
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800594:	53                   	push   %ebx
  800595:	51                   	push   %ecx
  800596:	52                   	push   %edx
  800597:	50                   	push   %eax
  800598:	e8 eb 14 00 00       	call   801a88 <__umoddi3>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	05 f4 20 80 00       	add    $0x8020f4,%eax
  8005a5:	8a 00                	mov    (%eax),%al
  8005a7:	0f be c0             	movsbl %al,%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	ff d0                	call   *%eax
  8005b6:	83 c4 10             	add    $0x10,%esp
}
  8005b9:	90                   	nop
  8005ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005c6:	7e 1c                	jle    8005e4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	8d 50 08             	lea    0x8(%eax),%edx
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	89 10                	mov    %edx,(%eax)
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	83 e8 08             	sub    $0x8,%eax
  8005dd:	8b 50 04             	mov    0x4(%eax),%edx
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	eb 40                	jmp    800624 <getuint+0x65>
	else if (lflag)
  8005e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005e8:	74 1e                	je     800608 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	8d 50 04             	lea    0x4(%eax),%edx
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	89 10                	mov    %edx,(%eax)
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	83 e8 04             	sub    $0x4,%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	eb 1c                	jmp    800624 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	8d 50 04             	lea    0x4(%eax),%edx
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	89 10                	mov    %edx,(%eax)
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	83 e8 04             	sub    $0x4,%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800629:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062d:	7e 1c                	jle    80064b <getint+0x25>
		return va_arg(*ap, long long);
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	8d 50 08             	lea    0x8(%eax),%edx
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	89 10                	mov    %edx,(%eax)
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 e8 08             	sub    $0x8,%eax
  800644:	8b 50 04             	mov    0x4(%eax),%edx
  800647:	8b 00                	mov    (%eax),%eax
  800649:	eb 38                	jmp    800683 <getint+0x5d>
	else if (lflag)
  80064b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064f:	74 1a                	je     80066b <getint+0x45>
		return va_arg(*ap, long);
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	8d 50 04             	lea    0x4(%eax),%edx
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	89 10                	mov    %edx,(%eax)
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	83 e8 04             	sub    $0x4,%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	99                   	cltd   
  800669:	eb 18                	jmp    800683 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	8d 50 04             	lea    0x4(%eax),%edx
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	89 10                	mov    %edx,(%eax)
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	83 e8 04             	sub    $0x4,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	99                   	cltd   
}
  800683:	5d                   	pop    %ebp
  800684:	c3                   	ret    

00800685 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068d:	eb 17                	jmp    8006a6 <vprintfmt+0x21>
			if (ch == '\0')
  80068f:	85 db                	test   %ebx,%ebx
  800691:	0f 84 af 03 00 00    	je     800a46 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	53                   	push   %ebx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a9:	8d 50 01             	lea    0x1(%eax),%edx
  8006ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8006af:	8a 00                	mov    (%eax),%al
  8006b1:	0f b6 d8             	movzbl %al,%ebx
  8006b4:	83 fb 25             	cmp    $0x25,%ebx
  8006b7:	75 d6                	jne    80068f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006b9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006bd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006dc:	8d 50 01             	lea    0x1(%eax),%edx
  8006df:	89 55 10             	mov    %edx,0x10(%ebp)
  8006e2:	8a 00                	mov    (%eax),%al
  8006e4:	0f b6 d8             	movzbl %al,%ebx
  8006e7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006ea:	83 f8 55             	cmp    $0x55,%eax
  8006ed:	0f 87 2b 03 00 00    	ja     800a1e <vprintfmt+0x399>
  8006f3:	8b 04 85 18 21 80 00 	mov    0x802118(,%eax,4),%eax
  8006fa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006fc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800700:	eb d7                	jmp    8006d9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800702:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800706:	eb d1                	jmp    8006d9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800708:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80070f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800712:	89 d0                	mov    %edx,%eax
  800714:	c1 e0 02             	shl    $0x2,%eax
  800717:	01 d0                	add    %edx,%eax
  800719:	01 c0                	add    %eax,%eax
  80071b:	01 d8                	add    %ebx,%eax
  80071d:	83 e8 30             	sub    $0x30,%eax
  800720:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800723:	8b 45 10             	mov    0x10(%ebp),%eax
  800726:	8a 00                	mov    (%eax),%al
  800728:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80072b:	83 fb 2f             	cmp    $0x2f,%ebx
  80072e:	7e 3e                	jle    80076e <vprintfmt+0xe9>
  800730:	83 fb 39             	cmp    $0x39,%ebx
  800733:	7f 39                	jg     80076e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800735:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800738:	eb d5                	jmp    80070f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	83 c0 04             	add    $0x4,%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80074e:	eb 1f                	jmp    80076f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800750:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800754:	79 83                	jns    8006d9 <vprintfmt+0x54>
				width = 0;
  800756:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80075d:	e9 77 ff ff ff       	jmp    8006d9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800762:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800769:	e9 6b ff ff ff       	jmp    8006d9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80076e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80076f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800773:	0f 89 60 ff ff ff    	jns    8006d9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800786:	e9 4e ff ff ff       	jmp    8006d9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80078b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80078e:	e9 46 ff ff ff       	jmp    8006d9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	83 c0 04             	add    $0x4,%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
			break;
  8007b3:	e9 89 02 00 00       	jmp    800a41 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	83 c0 04             	add    $0x4,%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007c9:	85 db                	test   %ebx,%ebx
  8007cb:	79 02                	jns    8007cf <vprintfmt+0x14a>
				err = -err;
  8007cd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007cf:	83 fb 64             	cmp    $0x64,%ebx
  8007d2:	7f 0b                	jg     8007df <vprintfmt+0x15a>
  8007d4:	8b 34 9d 60 1f 80 00 	mov    0x801f60(,%ebx,4),%esi
  8007db:	85 f6                	test   %esi,%esi
  8007dd:	75 19                	jne    8007f8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007df:	53                   	push   %ebx
  8007e0:	68 05 21 80 00       	push   $0x802105
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	ff 75 08             	pushl  0x8(%ebp)
  8007eb:	e8 5e 02 00 00       	call   800a4e <printfmt>
  8007f0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007f3:	e9 49 02 00 00       	jmp    800a41 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007f8:	56                   	push   %esi
  8007f9:	68 0e 21 80 00       	push   $0x80210e
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 45 02 00 00       	call   800a4e <printfmt>
  800809:	83 c4 10             	add    $0x10,%esp
			break;
  80080c:	e9 30 02 00 00       	jmp    800a41 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 30                	mov    (%eax),%esi
  800822:	85 f6                	test   %esi,%esi
  800824:	75 05                	jne    80082b <vprintfmt+0x1a6>
				p = "(null)";
  800826:	be 11 21 80 00       	mov    $0x802111,%esi
			if (width > 0 && padc != '-')
  80082b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082f:	7e 6d                	jle    80089e <vprintfmt+0x219>
  800831:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800835:	74 67                	je     80089e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	50                   	push   %eax
  80083e:	56                   	push   %esi
  80083f:	e8 0c 03 00 00       	call   800b50 <strnlen>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80084a:	eb 16                	jmp    800862 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80084c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	50                   	push   %eax
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80085f:	ff 4d e4             	decl   -0x1c(%ebp)
  800862:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800866:	7f e4                	jg     80084c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800868:	eb 34                	jmp    80089e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80086a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80086e:	74 1c                	je     80088c <vprintfmt+0x207>
  800870:	83 fb 1f             	cmp    $0x1f,%ebx
  800873:	7e 05                	jle    80087a <vprintfmt+0x1f5>
  800875:	83 fb 7e             	cmp    $0x7e,%ebx
  800878:	7e 12                	jle    80088c <vprintfmt+0x207>
					putch('?', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 3f                	push   $0x3f
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	eb 0f                	jmp    80089b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	53                   	push   %ebx
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80089b:	ff 4d e4             	decl   -0x1c(%ebp)
  80089e:	89 f0                	mov    %esi,%eax
  8008a0:	8d 70 01             	lea    0x1(%eax),%esi
  8008a3:	8a 00                	mov    (%eax),%al
  8008a5:	0f be d8             	movsbl %al,%ebx
  8008a8:	85 db                	test   %ebx,%ebx
  8008aa:	74 24                	je     8008d0 <vprintfmt+0x24b>
  8008ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b0:	78 b8                	js     80086a <vprintfmt+0x1e5>
  8008b2:	ff 4d e0             	decl   -0x20(%ebp)
  8008b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b9:	79 af                	jns    80086a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008bb:	eb 13                	jmp    8008d0 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	6a 20                	push   $0x20
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	ff d0                	call   *%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d4:	7f e7                	jg     8008bd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008d6:	e9 66 01 00 00       	jmp    800a41 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 3c fd ff ff       	call   800626 <getint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f9:	85 d2                	test   %edx,%edx
  8008fb:	79 23                	jns    800920 <vprintfmt+0x29b>
				putch('-', putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	6a 2d                	push   $0x2d
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	ff d0                	call   *%eax
  80090a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80090d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800910:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800913:	f7 d8                	neg    %eax
  800915:	83 d2 00             	adc    $0x0,%edx
  800918:	f7 da                	neg    %edx
  80091a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800920:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800927:	e9 bc 00 00 00       	jmp    8009e8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 e8             	pushl  -0x18(%ebp)
  800932:	8d 45 14             	lea    0x14(%ebp),%eax
  800935:	50                   	push   %eax
  800936:	e8 84 fc ff ff       	call   8005bf <getuint>
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800941:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800944:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80094b:	e9 98 00 00 00       	jmp    8009e8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	6a 58                	push   $0x58
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	ff d0                	call   *%eax
  80095d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	6a 58                	push   $0x58
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 58                	push   $0x58
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
			break;
  800980:	e9 bc 00 00 00       	jmp    800a41 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 30                	push   $0x30
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	6a 78                	push   $0x78
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 c0 04             	add    $0x4,%eax
  8009ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	83 e8 04             	sub    $0x4,%eax
  8009b4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009c7:	eb 1f                	jmp    8009e8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	e8 e7 fb ff ff       	call   8005bf <getuint>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009e1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009e8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ef:	83 ec 04             	sub    $0x4,%esp
  8009f2:	52                   	push   %edx
  8009f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 00 fb ff ff       	call   800508 <printnum>
  800a08:	83 c4 20             	add    $0x20,%esp
			break;
  800a0b:	eb 34                	jmp    800a41 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	53                   	push   %ebx
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			break;
  800a1c:	eb 23                	jmp    800a41 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 25                	push   $0x25
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a2e:	ff 4d 10             	decl   0x10(%ebp)
  800a31:	eb 03                	jmp    800a36 <vprintfmt+0x3b1>
  800a33:	ff 4d 10             	decl   0x10(%ebp)
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	8a 00                	mov    (%eax),%al
  800a3c:	3c 25                	cmp    $0x25,%al
  800a3e:	75 f3                	jne    800a33 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a40:	90                   	nop
		}
	}
  800a41:	e9 47 fc ff ff       	jmp    80068d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a46:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4a:	5b                   	pop    %ebx
  800a4b:	5e                   	pop    %esi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a54:	8d 45 10             	lea    0x10(%ebp),%eax
  800a57:	83 c0 04             	add    $0x4,%eax
  800a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a60:	ff 75 f4             	pushl  -0xc(%ebp)
  800a63:	50                   	push   %eax
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	ff 75 08             	pushl  0x8(%ebp)
  800a6a:	e8 16 fc ff ff       	call   800685 <vprintfmt>
  800a6f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a72:	90                   	nop
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8b 40 08             	mov    0x8(%eax),%eax
  800a7e:	8d 50 01             	lea    0x1(%eax),%edx
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8b 10                	mov    (%eax),%edx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8b 40 04             	mov    0x4(%eax),%eax
  800a92:	39 c2                	cmp    %eax,%edx
  800a94:	73 12                	jae    800aa8 <sprintputch+0x33>
		*b->buf++ = ch;
  800a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa1:	89 0a                	mov    %ecx,(%edx)
  800aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa6:	88 10                	mov    %dl,(%eax)
}
  800aa8:	90                   	nop
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	01 d0                	add    %edx,%eax
  800ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800acc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ad0:	74 06                	je     800ad8 <vsnprintf+0x2d>
  800ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad6:	7f 07                	jg     800adf <vsnprintf+0x34>
		return -E_INVAL;
  800ad8:	b8 03 00 00 00       	mov    $0x3,%eax
  800add:	eb 20                	jmp    800aff <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800adf:	ff 75 14             	pushl  0x14(%ebp)
  800ae2:	ff 75 10             	pushl  0x10(%ebp)
  800ae5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ae8:	50                   	push   %eax
  800ae9:	68 75 0a 80 00       	push   $0x800a75
  800aee:	e8 92 fb ff ff       	call   800685 <vprintfmt>
  800af3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b07:	8d 45 10             	lea    0x10(%ebp),%eax
  800b0a:	83 c0 04             	add    $0x4,%eax
  800b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	ff 75 f4             	pushl  -0xc(%ebp)
  800b16:	50                   	push   %eax
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	ff 75 08             	pushl  0x8(%ebp)
  800b1d:	e8 89 ff ff ff       	call   800aab <vsnprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b3a:	eb 06                	jmp    800b42 <strlen+0x15>
		n++;
  800b3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b3f:	ff 45 08             	incl   0x8(%ebp)
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	84 c0                	test   %al,%al
  800b49:	75 f1                	jne    800b3c <strlen+0xf>
		n++;
	return n;
  800b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b5d:	eb 09                	jmp    800b68 <strnlen+0x18>
		n++;
  800b5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b62:	ff 45 08             	incl   0x8(%ebp)
  800b65:	ff 4d 0c             	decl   0xc(%ebp)
  800b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6c:	74 09                	je     800b77 <strnlen+0x27>
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	84 c0                	test   %al,%al
  800b75:	75 e8                	jne    800b5f <strnlen+0xf>
		n++;
	return n;
  800b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b88:	90                   	nop
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8d 50 01             	lea    0x1(%eax),%edx
  800b8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b9b:	8a 12                	mov    (%edx),%dl
  800b9d:	88 10                	mov    %dl,(%eax)
  800b9f:	8a 00                	mov    (%eax),%al
  800ba1:	84 c0                	test   %al,%al
  800ba3:	75 e4                	jne    800b89 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbd:	eb 1f                	jmp    800bde <strncpy+0x34>
		*dst++ = *src;
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8d 50 01             	lea    0x1(%eax),%edx
  800bc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcb:	8a 12                	mov    (%edx),%dl
  800bcd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	84 c0                	test   %al,%al
  800bd6:	74 03                	je     800bdb <strncpy+0x31>
			src++;
  800bd8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bdb:	ff 45 fc             	incl   -0x4(%ebp)
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800be4:	72 d9                	jb     800bbf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfb:	74 30                	je     800c2d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bfd:	eb 16                	jmp    800c15 <strlcpy+0x2a>
			*dst++ = *src++;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 08             	mov    %edx,0x8(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c11:	8a 12                	mov    (%edx),%dl
  800c13:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c15:	ff 4d 10             	decl   0x10(%ebp)
  800c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1c:	74 09                	je     800c27 <strlcpy+0x3c>
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	84 c0                	test   %al,%al
  800c25:	75 d8                	jne    800bff <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c33:	29 c2                	sub    %eax,%edx
  800c35:	89 d0                	mov    %edx,%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c3c:	eb 06                	jmp    800c44 <strcmp+0xb>
		p++, q++;
  800c3e:	ff 45 08             	incl   0x8(%ebp)
  800c41:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	84 c0                	test   %al,%al
  800c4b:	74 0e                	je     800c5b <strcmp+0x22>
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8a 10                	mov    (%eax),%dl
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	38 c2                	cmp    %al,%dl
  800c59:	74 e3                	je     800c3e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	0f b6 d0             	movzbl %al,%edx
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f b6 c0             	movzbl %al,%eax
  800c6b:	29 c2                	sub    %eax,%edx
  800c6d:	89 d0                	mov    %edx,%eax
}
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c74:	eb 09                	jmp    800c7f <strncmp+0xe>
		n--, p++, q++;
  800c76:	ff 4d 10             	decl   0x10(%ebp)
  800c79:	ff 45 08             	incl   0x8(%ebp)
  800c7c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 17                	je     800c9c <strncmp+0x2b>
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	84 c0                	test   %al,%al
  800c8c:	74 0e                	je     800c9c <strncmp+0x2b>
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 10                	mov    (%eax),%dl
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	38 c2                	cmp    %al,%dl
  800c9a:	74 da                	je     800c76 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca0:	75 07                	jne    800ca9 <strncmp+0x38>
		return 0;
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	eb 14                	jmp    800cbd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	0f b6 d0             	movzbl %al,%edx
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	0f b6 c0             	movzbl %al,%eax
  800cb9:	29 c2                	sub    %eax,%edx
  800cbb:	89 d0                	mov    %edx,%eax
}
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 04             	sub    $0x4,%esp
  800cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccb:	eb 12                	jmp    800cdf <strchr+0x20>
		if (*s == c)
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd5:	75 05                	jne    800cdc <strchr+0x1d>
			return (char *) s;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	eb 11                	jmp    800ced <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	75 e5                	jne    800ccd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 04             	sub    $0x4,%esp
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cfb:	eb 0d                	jmp    800d0a <strfind+0x1b>
		if (*s == c)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d05:	74 0e                	je     800d15 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d07:	ff 45 08             	incl   0x8(%ebp)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	75 ea                	jne    800cfd <strfind+0xe>
  800d13:	eb 01                	jmp    800d16 <strfind+0x27>
		if (*s == c)
			break;
  800d15:	90                   	nop
	return (char *) s;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d2d:	eb 0e                	jmp    800d3d <memset+0x22>
		*p++ = c;
  800d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d3d:	ff 4d f8             	decl   -0x8(%ebp)
  800d40:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d44:	79 e9                	jns    800d2f <memset+0x14>
		*p++ = c;

	return v;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d5d:	eb 16                	jmp    800d75 <memcpy+0x2a>
		*d++ = *s++;
  800d5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d62:	8d 50 01             	lea    0x1(%eax),%edx
  800d65:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d75:	8b 45 10             	mov    0x10(%ebp),%eax
  800d78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	75 dd                	jne    800d5f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d9f:	73 50                	jae    800df1 <memmove+0x6a>
  800da1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	01 d0                	add    %edx,%eax
  800da9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dac:	76 43                	jbe    800df1 <memmove+0x6a>
		s += n;
  800dae:	8b 45 10             	mov    0x10(%ebp),%eax
  800db1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dba:	eb 10                	jmp    800dcc <memmove+0x45>
			*--d = *--s;
  800dbc:	ff 4d f8             	decl   -0x8(%ebp)
  800dbf:	ff 4d fc             	decl   -0x4(%ebp)
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	8a 10                	mov    (%eax),%dl
  800dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dca:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd2:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	75 e3                	jne    800dbc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd9:	eb 23                	jmp    800dfe <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ded:	8a 12                	mov    (%edx),%dl
  800def:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800df1:	8b 45 10             	mov    0x10(%ebp),%eax
  800df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	75 dd                	jne    800ddb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e15:	eb 2a                	jmp    800e41 <memcmp+0x3e>
		if (*s1 != *s2)
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	8a 10                	mov    (%eax),%dl
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	38 c2                	cmp    %al,%dl
  800e23:	74 16                	je     800e3b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	0f b6 d0             	movzbl %al,%edx
  800e2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f b6 c0             	movzbl %al,%eax
  800e35:	29 c2                	sub    %eax,%edx
  800e37:	89 d0                	mov    %edx,%eax
  800e39:	eb 18                	jmp    800e53 <memcmp+0x50>
		s1++, s2++;
  800e3b:	ff 45 fc             	incl   -0x4(%ebp)
  800e3e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e47:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	75 c9                	jne    800e17 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 d0                	add    %edx,%eax
  800e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e66:	eb 15                	jmp    800e7d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 d0             	movzbl %al,%edx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	0f b6 c0             	movzbl %al,%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 0d                	je     800e87 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e83:	72 e3                	jb     800e68 <memfind+0x13>
  800e85:	eb 01                	jmp    800e88 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e87:	90                   	nop
	return (void *) s;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e9a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea1:	eb 03                	jmp    800ea6 <strtol+0x19>
		s++;
  800ea3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	3c 20                	cmp    $0x20,%al
  800ead:	74 f4                	je     800ea3 <strtol+0x16>
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	3c 09                	cmp    $0x9,%al
  800eb6:	74 eb                	je     800ea3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3c 2b                	cmp    $0x2b,%al
  800ebf:	75 05                	jne    800ec6 <strtol+0x39>
		s++;
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	eb 13                	jmp    800ed9 <strtol+0x4c>
	else if (*s == '-')
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3c 2d                	cmp    $0x2d,%al
  800ecd:	75 0a                	jne    800ed9 <strtol+0x4c>
		s++, neg = 1;
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edd:	74 06                	je     800ee5 <strtol+0x58>
  800edf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ee3:	75 20                	jne    800f05 <strtol+0x78>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 30                	cmp    $0x30,%al
  800eec:	75 17                	jne    800f05 <strtol+0x78>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	40                   	inc    %eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 78                	cmp    $0x78,%al
  800ef6:	75 0d                	jne    800f05 <strtol+0x78>
		s += 2, base = 16;
  800ef8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800efc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f03:	eb 28                	jmp    800f2d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f09:	75 15                	jne    800f20 <strtol+0x93>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	3c 30                	cmp    $0x30,%al
  800f12:	75 0c                	jne    800f20 <strtol+0x93>
		s++, base = 8;
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f1e:	eb 0d                	jmp    800f2d <strtol+0xa0>
	else if (base == 0)
  800f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f24:	75 07                	jne    800f2d <strtol+0xa0>
		base = 10;
  800f26:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 2f                	cmp    $0x2f,%al
  800f34:	7e 19                	jle    800f4f <strtol+0xc2>
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	3c 39                	cmp    $0x39,%al
  800f3d:	7f 10                	jg     800f4f <strtol+0xc2>
			dig = *s - '0';
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f be c0             	movsbl %al,%eax
  800f47:	83 e8 30             	sub    $0x30,%eax
  800f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f4d:	eb 42                	jmp    800f91 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	3c 60                	cmp    $0x60,%al
  800f56:	7e 19                	jle    800f71 <strtol+0xe4>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	3c 7a                	cmp    $0x7a,%al
  800f5f:	7f 10                	jg     800f71 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be c0             	movsbl %al,%eax
  800f69:	83 e8 57             	sub    $0x57,%eax
  800f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f6f:	eb 20                	jmp    800f91 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 40                	cmp    $0x40,%al
  800f78:	7e 39                	jle    800fb3 <strtol+0x126>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 5a                	cmp    $0x5a,%al
  800f81:	7f 30                	jg     800fb3 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f be c0             	movsbl %al,%eax
  800f8b:	83 e8 37             	sub    $0x37,%eax
  800f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f94:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f97:	7d 19                	jge    800fb2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fa3:	89 c2                	mov    %eax,%edx
  800fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fad:	e9 7b ff ff ff       	jmp    800f2d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fb2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb7:	74 08                	je     800fc1 <strtol+0x134>
		*endptr = (char *) s;
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fc5:	74 07                	je     800fce <strtol+0x141>
  800fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fca:	f7 d8                	neg    %eax
  800fcc:	eb 03                	jmp    800fd1 <strtol+0x144>
  800fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <ltostr>:

void
ltostr(long value, char *str)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fe0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fe7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800feb:	79 13                	jns    801000 <ltostr+0x2d>
	{
		neg = 1;
  800fed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ffa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ffd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801008:	99                   	cltd   
  801009:	f7 f9                	idiv   %ecx
  80100b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801017:	89 c2                	mov    %eax,%edx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801021:	83 c2 30             	add    $0x30,%edx
  801024:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801026:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801029:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80102e:	f7 e9                	imul   %ecx
  801030:	c1 fa 02             	sar    $0x2,%edx
  801033:	89 c8                	mov    %ecx,%eax
  801035:	c1 f8 1f             	sar    $0x1f,%eax
  801038:	29 c2                	sub    %eax,%edx
  80103a:	89 d0                	mov    %edx,%eax
  80103c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80103f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801042:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801047:	f7 e9                	imul   %ecx
  801049:	c1 fa 02             	sar    $0x2,%edx
  80104c:	89 c8                	mov    %ecx,%eax
  80104e:	c1 f8 1f             	sar    $0x1f,%eax
  801051:	29 c2                	sub    %eax,%edx
  801053:	89 d0                	mov    %edx,%eax
  801055:	c1 e0 02             	shl    $0x2,%eax
  801058:	01 d0                	add    %edx,%eax
  80105a:	01 c0                	add    %eax,%eax
  80105c:	29 c1                	sub    %eax,%ecx
  80105e:	89 ca                	mov    %ecx,%edx
  801060:	85 d2                	test   %edx,%edx
  801062:	75 9c                	jne    801000 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801064:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106e:	48                   	dec    %eax
  80106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801072:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801076:	74 3d                	je     8010b5 <ltostr+0xe2>
		start = 1 ;
  801078:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80107f:	eb 34                	jmp    8010b5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80108e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	01 c2                	add    %eax,%edx
  801096:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 c8                	add    %ecx,%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	01 c2                	add    %eax,%edx
  8010aa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010ad:	88 02                	mov    %al,(%edx)
		start++ ;
  8010af:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010b2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010bb:	7c c4                	jl     801081 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010c8:	90                   	nop
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010d1:	ff 75 08             	pushl  0x8(%ebp)
  8010d4:	e8 54 fa ff ff       	call   800b2d <strlen>
  8010d9:	83 c4 04             	add    $0x4,%esp
  8010dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	e8 46 fa ff ff       	call   800b2d <strlen>
  8010e7:	83 c4 04             	add    $0x4,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010fb:	eb 17                	jmp    801114 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 c2                	add    %eax,%edx
  801105:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801111:	ff 45 fc             	incl   -0x4(%ebp)
  801114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801117:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80111a:	7c e1                	jl     8010fd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80111c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801123:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80112a:	eb 1f                	jmp    80114b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	01 c2                	add    %eax,%edx
  80113c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 c8                	add    %ecx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801148:	ff 45 f8             	incl   -0x8(%ebp)
  80114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801151:	7c d9                	jl     80112c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	c6 00 00             	movb   $0x0,(%eax)
}
  80115e:	90                   	nop
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801164:	8b 45 14             	mov    0x14(%ebp),%eax
  801167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80116d:	8b 45 14             	mov    0x14(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801184:	eb 0c                	jmp    801192 <strsplit+0x31>
			*string++ = 0;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 08             	mov    %edx,0x8(%ebp)
  80118f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	84 c0                	test   %al,%al
  801199:	74 18                	je     8011b3 <strsplit+0x52>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f be c0             	movsbl %al,%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 0c             	pushl  0xc(%ebp)
  8011a7:	e8 13 fb ff ff       	call   800cbf <strchr>
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	75 d3                	jne    801186 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	84 c0                	test   %al,%al
  8011ba:	74 5a                	je     801216 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	83 f8 0f             	cmp    $0xf,%eax
  8011c4:	75 07                	jne    8011cd <strsplit+0x6c>
		{
			return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	eb 66                	jmp    801233 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d5:	8b 55 14             	mov    0x14(%ebp),%edx
  8011d8:	89 0a                	mov    %ecx,(%edx)
  8011da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 c2                	add    %eax,%edx
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011eb:	eb 03                	jmp    8011f0 <strsplit+0x8f>
			string++;
  8011ed:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	84 c0                	test   %al,%al
  8011f7:	74 8b                	je     801184 <strsplit+0x23>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	0f be c0             	movsbl %al,%eax
  801201:	50                   	push   %eax
  801202:	ff 75 0c             	pushl  0xc(%ebp)
  801205:	e8 b5 fa ff ff       	call   800cbf <strchr>
  80120a:	83 c4 08             	add    $0x8,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	74 dc                	je     8011ed <strsplit+0x8c>
			string++;
	}
  801211:	e9 6e ff ff ff       	jmp    801184 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801216:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80122e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80123b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801242:	eb 4c                	jmp    801290 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  801244:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 40                	cmp    $0x40,%al
  801250:	7e 27                	jle    801279 <str2lower+0x44>
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 5a                	cmp    $0x5a,%al
  80125e:	7f 19                	jg     801279 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801260:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	01 d0                	add    %edx,%eax
  801268:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80126b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126e:	01 ca                	add    %ecx,%edx
  801270:	8a 12                	mov    (%edx),%dl
  801272:	83 c2 20             	add    $0x20,%edx
  801275:	88 10                	mov    %dl,(%eax)
  801277:	eb 14                	jmp    80128d <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	01 c2                	add    %eax,%edx
  801281:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 c8                	add    %ecx,%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  80128d:	ff 45 fc             	incl   -0x4(%ebp)
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	e8 95 f8 ff ff       	call   800b2d <strlen>
  801298:	83 c4 04             	add    $0x4,%esp
  80129b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80129e:	7f a4                	jg     801244 <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return NULL;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	57                   	push   %edi
  8012ab:	56                   	push   %esi
  8012ac:	53                   	push   %ebx
  8012ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c2:	cd 30                	int    $0x30
  8012c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	5b                   	pop    %ebx
  8012ce:	5e                   	pop    %esi
  8012cf:	5f                   	pop    %edi
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    

008012d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	52                   	push   %edx
  8012ea:	ff 75 0c             	pushl  0xc(%ebp)
  8012ed:	50                   	push   %eax
  8012ee:	6a 00                	push   $0x0
  8012f0:	e8 b2 ff ff ff       	call   8012a7 <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 01                	push   $0x1
  80130a:	e8 98 ff ff ff       	call   8012a7 <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	52                   	push   %edx
  801324:	50                   	push   %eax
  801325:	6a 05                	push   $0x5
  801327:	e8 7b ff ff ff       	call   8012a7 <syscall>
  80132c:	83 c4 18             	add    $0x18,%esp
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801336:	8b 75 18             	mov    0x18(%ebp),%esi
  801339:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80133c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	51                   	push   %ecx
  801348:	52                   	push   %edx
  801349:	50                   	push   %eax
  80134a:	6a 06                	push   $0x6
  80134c:	e8 56 ff ff ff       	call   8012a7 <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80135e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	52                   	push   %edx
  80136b:	50                   	push   %eax
  80136c:	6a 07                	push   $0x7
  80136e:	e8 34 ff ff ff       	call   8012a7 <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	6a 08                	push   $0x8
  801389:	e8 19 ff ff ff       	call   8012a7 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 09                	push   $0x9
  8013a2:	e8 00 ff ff ff       	call   8012a7 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 0a                	push   $0xa
  8013bb:	e8 e7 fe ff ff       	call   8012a7 <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 0b                	push   $0xb
  8013d4:	e8 ce fe ff ff       	call   8012a7 <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 0c                	push   $0xc
  8013ed:	e8 b5 fe ff ff       	call   8012a7 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	6a 0d                	push   $0xd
  801407:	e8 9b fe ff ff       	call   8012a7 <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 0e                	push   $0xe
  801420:	e8 82 fe ff ff       	call   8012a7 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 11                	push   $0x11
  80143a:	e8 68 fe ff ff       	call   8012a7 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
}
  801442:	90                   	nop
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 12                	push   $0x12
  801454:	e8 4e fe ff ff       	call   8012a7 <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_cputc>:


void
sys_cputc(const char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80146b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	50                   	push   %eax
  801478:	6a 13                	push   $0x13
  80147a:	e8 28 fe ff ff       	call   8012a7 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	90                   	nop
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 14                	push   $0x14
  801494:	e8 0e fe ff ff       	call   8012a7 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	ff 75 0c             	pushl  0xc(%ebp)
  8014ae:	50                   	push   %eax
  8014af:	6a 15                	push   $0x15
  8014b1:	e8 f1 fd ff ff       	call   8012a7 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	52                   	push   %edx
  8014cb:	50                   	push   %eax
  8014cc:	6a 18                	push   $0x18
  8014ce:	e8 d4 fd ff ff       	call   8012a7 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	52                   	push   %edx
  8014e8:	50                   	push   %eax
  8014e9:	6a 16                	push   $0x16
  8014eb:	e8 b7 fd ff ff       	call   8012a7 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	52                   	push   %edx
  801506:	50                   	push   %eax
  801507:	6a 17                	push   $0x17
  801509:	e8 99 fd ff ff       	call   8012a7 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	90                   	nop
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801520:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801523:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	51                   	push   %ecx
  80152d:	52                   	push   %edx
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	50                   	push   %eax
  801532:	6a 19                	push   $0x19
  801534:	e8 6e fd ff ff       	call   8012a7 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801541:	8b 55 0c             	mov    0xc(%ebp),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 1a                	push   $0x1a
  801551:	e8 51 fd ff ff       	call   8012a7 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80155e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	51                   	push   %ecx
  80156c:	52                   	push   %edx
  80156d:	50                   	push   %eax
  80156e:	6a 1b                	push   $0x1b
  801570:	e8 32 fd ff ff       	call   8012a7 <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	52                   	push   %edx
  80158a:	50                   	push   %eax
  80158b:	6a 1c                	push   $0x1c
  80158d:	e8 15 fd ff ff       	call   8012a7 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 1d                	push   $0x1d
  8015a6:	e8 fc fc ff ff       	call   8012a7 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	6a 00                	push   $0x0
  8015b8:	ff 75 14             	pushl  0x14(%ebp)
  8015bb:	ff 75 10             	pushl  0x10(%ebp)
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	50                   	push   %eax
  8015c2:	6a 1e                	push   $0x1e
  8015c4:	e8 de fc ff ff       	call   8012a7 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	50                   	push   %eax
  8015dd:	6a 1f                	push   $0x1f
  8015df:	e8 c3 fc ff ff       	call   8012a7 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
}
  8015e7:	90                   	nop
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	50                   	push   %eax
  8015f9:	6a 20                	push   $0x20
  8015fb:	e8 a7 fc ff ff       	call   8012a7 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 02                	push   $0x2
  801614:	e8 8e fc ff ff       	call   8012a7 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 03                	push   $0x3
  80162d:	e8 75 fc ff ff       	call   8012a7 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 04                	push   $0x4
  801646:	e8 5c fc ff ff       	call   8012a7 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_exit_env>:


void sys_exit_env(void)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 21                	push   $0x21
  80165f:	e8 43 fc ff ff       	call   8012a7 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801670:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801673:	8d 50 04             	lea    0x4(%eax),%edx
  801676:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 22                	push   $0x22
  801683:	e8 1f fc ff ff       	call   8012a7 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
	return result;
  80168b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801691:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801694:	89 01                	mov    %eax,(%ecx)
  801696:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	c9                   	leave  
  80169d:	c2 04 00             	ret    $0x4

008016a0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 10             	pushl  0x10(%ebp)
  8016aa:	ff 75 0c             	pushl  0xc(%ebp)
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	6a 10                	push   $0x10
  8016b2:	e8 f0 fb ff ff       	call   8012a7 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ba:	90                   	nop
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_rcr2>:
uint32 sys_rcr2()
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 23                	push   $0x23
  8016cc:	e8 d6 fb ff ff       	call   8012a7 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016e2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	50                   	push   %eax
  8016ef:	6a 24                	push   $0x24
  8016f1:	e8 b1 fb ff ff       	call   8012a7 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f9:	90                   	nop
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <rsttst>:
void rsttst()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 26                	push   $0x26
  80170b:	e8 97 fb ff ff       	call   8012a7 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
	return ;
  801713:	90                   	nop
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	8b 45 14             	mov    0x14(%ebp),%eax
  80171f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801722:	8b 55 18             	mov    0x18(%ebp),%edx
  801725:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801729:	52                   	push   %edx
  80172a:	50                   	push   %eax
  80172b:	ff 75 10             	pushl  0x10(%ebp)
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	6a 25                	push   $0x25
  801736:	e8 6c fb ff ff       	call   8012a7 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
	return ;
  80173e:	90                   	nop
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <chktst>:
void chktst(uint32 n)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	6a 27                	push   $0x27
  801751:	e8 51 fb ff ff       	call   8012a7 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
	return ;
  801759:	90                   	nop
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <inctst>:

void inctst()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 28                	push   $0x28
  80176b:	e8 37 fb ff ff       	call   8012a7 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
	return ;
  801773:	90                   	nop
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <gettst>:
uint32 gettst()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 29                	push   $0x29
  801785:	e8 1d fb ff ff       	call   8012a7 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 2a                	push   $0x2a
  8017a1:	e8 01 fb ff ff       	call   8012a7 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
  8017a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017ac:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017b0:	75 07                	jne    8017b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b7:	eb 05                	jmp    8017be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 2a                	push   $0x2a
  8017d2:	e8 d0 fa ff ff       	call   8012a7 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
  8017da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017dd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017e1:	75 07                	jne    8017ea <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e8:	eb 05                	jmp    8017ef <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 2a                	push   $0x2a
  801803:	e8 9f fa ff ff       	call   8012a7 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
  80180b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80180e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801812:	75 07                	jne    80181b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801814:	b8 01 00 00 00       	mov    $0x1,%eax
  801819:	eb 05                	jmp    801820 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 2a                	push   $0x2a
  801834:	e8 6e fa ff ff       	call   8012a7 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
  80183c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80183f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801843:	75 07                	jne    80184c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801845:	b8 01 00 00 00       	mov    $0x1,%eax
  80184a:	eb 05                	jmp    801851 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	6a 2b                	push   $0x2b
  801863:	e8 3f fa ff ff       	call   8012a7 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
	return ;
  80186b:	90                   	nop
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801872:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801875:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	53                   	push   %ebx
  801881:	51                   	push   %ecx
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 2c                	push   $0x2c
  801886:	e8 1c fa ff ff       	call   8012a7 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 2d                	push   $0x2d
  8018a6:	e8 fc f9 ff ff       	call   8012a7 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	51                   	push   %ecx
  8018bf:	ff 75 10             	pushl  0x10(%ebp)
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 2e                	push   $0x2e
  8018c6:	e8 dc f9 ff ff       	call   8012a7 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	6a 0f                	push   $0xf
  8018e2:	e8 c0 f9 ff ff       	call   8012a7 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	50                   	push   %eax
  8018fc:	6a 2f                	push   $0x2f
  8018fe:	e8 a4 f9 ff ff       	call   8012a7 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp

}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 30                	push   $0x30
  801919:	e8 89 f9 ff ff       	call   8012a7 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
	return;
  801921:	90                   	nop
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	6a 31                	push   $0x31
  801935:	e8 6d f9 ff ff       	call   8012a7 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
	return;
  80193d:	90                   	nop
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 32                	push   $0x32
  80194f:	e8 53 f9 ff ff       	call   8012a7 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_env_set_nice>:
void sys_env_set_nice(int nice){
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	50                   	push   %eax
  801968:	6a 33                	push   $0x33
  80196a:	e8 38 f9 ff ff       	call   8012a7 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    
  801975:	66 90                	xchg   %ax,%ax
  801977:	90                   	nop

00801978 <__udivdi3>:
  801978:	55                   	push   %ebp
  801979:	57                   	push   %edi
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801983:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198f:	89 ca                	mov    %ecx,%edx
  801991:	89 f8                	mov    %edi,%eax
  801993:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801997:	85 f6                	test   %esi,%esi
  801999:	75 2d                	jne    8019c8 <__udivdi3+0x50>
  80199b:	39 cf                	cmp    %ecx,%edi
  80199d:	77 65                	ja     801a04 <__udivdi3+0x8c>
  80199f:	89 fd                	mov    %edi,%ebp
  8019a1:	85 ff                	test   %edi,%edi
  8019a3:	75 0b                	jne    8019b0 <__udivdi3+0x38>
  8019a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019aa:	31 d2                	xor    %edx,%edx
  8019ac:	f7 f7                	div    %edi
  8019ae:	89 c5                	mov    %eax,%ebp
  8019b0:	31 d2                	xor    %edx,%edx
  8019b2:	89 c8                	mov    %ecx,%eax
  8019b4:	f7 f5                	div    %ebp
  8019b6:	89 c1                	mov    %eax,%ecx
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	f7 f5                	div    %ebp
  8019bc:	89 cf                	mov    %ecx,%edi
  8019be:	89 fa                	mov    %edi,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	77 28                	ja     8019f4 <__udivdi3+0x7c>
  8019cc:	0f bd fe             	bsr    %esi,%edi
  8019cf:	83 f7 1f             	xor    $0x1f,%edi
  8019d2:	75 40                	jne    801a14 <__udivdi3+0x9c>
  8019d4:	39 ce                	cmp    %ecx,%esi
  8019d6:	72 0a                	jb     8019e2 <__udivdi3+0x6a>
  8019d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019dc:	0f 87 9e 00 00 00    	ja     801a80 <__udivdi3+0x108>
  8019e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e7:	89 fa                	mov    %edi,%edx
  8019e9:	83 c4 1c             	add    $0x1c,%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5f                   	pop    %edi
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    
  8019f1:	8d 76 00             	lea    0x0(%esi),%esi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	31 c0                	xor    %eax,%eax
  8019f8:	89 fa                	mov    %edi,%edx
  8019fa:	83 c4 1c             	add    $0x1c,%esp
  8019fd:	5b                   	pop    %ebx
  8019fe:	5e                   	pop    %esi
  8019ff:	5f                   	pop    %edi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	89 d8                	mov    %ebx,%eax
  801a06:	f7 f7                	div    %edi
  801a08:	31 ff                	xor    %edi,%edi
  801a0a:	89 fa                	mov    %edi,%edx
  801a0c:	83 c4 1c             	add    $0x1c,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
  801a14:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a19:	89 eb                	mov    %ebp,%ebx
  801a1b:	29 fb                	sub    %edi,%ebx
  801a1d:	89 f9                	mov    %edi,%ecx
  801a1f:	d3 e6                	shl    %cl,%esi
  801a21:	89 c5                	mov    %eax,%ebp
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ed                	shr    %cl,%ebp
  801a27:	89 e9                	mov    %ebp,%ecx
  801a29:	09 f1                	or     %esi,%ecx
  801a2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e0                	shl    %cl,%eax
  801a33:	89 c5                	mov    %eax,%ebp
  801a35:	89 d6                	mov    %edx,%esi
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 ee                	shr    %cl,%esi
  801a3b:	89 f9                	mov    %edi,%ecx
  801a3d:	d3 e2                	shl    %cl,%edx
  801a3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a43:	88 d9                	mov    %bl,%cl
  801a45:	d3 e8                	shr    %cl,%eax
  801a47:	09 c2                	or     %eax,%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	f7 74 24 0c          	divl   0xc(%esp)
  801a51:	89 d6                	mov    %edx,%esi
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	f7 e5                	mul    %ebp
  801a57:	39 d6                	cmp    %edx,%esi
  801a59:	72 19                	jb     801a74 <__udivdi3+0xfc>
  801a5b:	74 0b                	je     801a68 <__udivdi3+0xf0>
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 58 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a6c:	89 f9                	mov    %edi,%ecx
  801a6e:	d3 e2                	shl    %cl,%edx
  801a70:	39 c2                	cmp    %eax,%edx
  801a72:	73 e9                	jae    801a5d <__udivdi3+0xe5>
  801a74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a77:	31 ff                	xor    %edi,%edi
  801a79:	e9 40 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	31 c0                	xor    %eax,%eax
  801a82:	e9 37 ff ff ff       	jmp    8019be <__udivdi3+0x46>
  801a87:	90                   	nop

00801a88 <__umoddi3>:
  801a88:	55                   	push   %ebp
  801a89:	57                   	push   %edi
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa7:	89 f3                	mov    %esi,%ebx
  801aa9:	89 fa                	mov    %edi,%edx
  801aab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aaf:	89 34 24             	mov    %esi,(%esp)
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	75 1a                	jne    801ad0 <__umoddi3+0x48>
  801ab6:	39 f7                	cmp    %esi,%edi
  801ab8:	0f 86 a2 00 00 00    	jbe    801b60 <__umoddi3+0xd8>
  801abe:	89 c8                	mov    %ecx,%eax
  801ac0:	89 f2                	mov    %esi,%edx
  801ac2:	f7 f7                	div    %edi
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	31 d2                	xor    %edx,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	39 f0                	cmp    %esi,%eax
  801ad2:	0f 87 ac 00 00 00    	ja     801b84 <__umoddi3+0xfc>
  801ad8:	0f bd e8             	bsr    %eax,%ebp
  801adb:	83 f5 1f             	xor    $0x1f,%ebp
  801ade:	0f 84 ac 00 00 00    	je     801b90 <__umoddi3+0x108>
  801ae4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae9:	29 ef                	sub    %ebp,%edi
  801aeb:	89 fe                	mov    %edi,%esi
  801aed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e0                	shl    %cl,%eax
  801af5:	89 d7                	mov    %edx,%edi
  801af7:	89 f1                	mov    %esi,%ecx
  801af9:	d3 ef                	shr    %cl,%edi
  801afb:	09 c7                	or     %eax,%edi
  801afd:	89 e9                	mov    %ebp,%ecx
  801aff:	d3 e2                	shl    %cl,%edx
  801b01:	89 14 24             	mov    %edx,(%esp)
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	d3 e0                	shl    %cl,%eax
  801b08:	89 c2                	mov    %eax,%edx
  801b0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b18:	89 f1                	mov    %esi,%ecx
  801b1a:	d3 e8                	shr    %cl,%eax
  801b1c:	09 d0                	or     %edx,%eax
  801b1e:	d3 eb                	shr    %cl,%ebx
  801b20:	89 da                	mov    %ebx,%edx
  801b22:	f7 f7                	div    %edi
  801b24:	89 d3                	mov    %edx,%ebx
  801b26:	f7 24 24             	mull   (%esp)
  801b29:	89 c6                	mov    %eax,%esi
  801b2b:	89 d1                	mov    %edx,%ecx
  801b2d:	39 d3                	cmp    %edx,%ebx
  801b2f:	0f 82 87 00 00 00    	jb     801bbc <__umoddi3+0x134>
  801b35:	0f 84 91 00 00 00    	je     801bcc <__umoddi3+0x144>
  801b3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3f:	29 f2                	sub    %esi,%edx
  801b41:	19 cb                	sbb    %ecx,%ebx
  801b43:	89 d8                	mov    %ebx,%eax
  801b45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b49:	d3 e0                	shl    %cl,%eax
  801b4b:	89 e9                	mov    %ebp,%ecx
  801b4d:	d3 ea                	shr    %cl,%edx
  801b4f:	09 d0                	or     %edx,%eax
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 eb                	shr    %cl,%ebx
  801b55:	89 da                	mov    %ebx,%edx
  801b57:	83 c4 1c             	add    $0x1c,%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    
  801b5f:	90                   	nop
  801b60:	89 fd                	mov    %edi,%ebp
  801b62:	85 ff                	test   %edi,%edi
  801b64:	75 0b                	jne    801b71 <__umoddi3+0xe9>
  801b66:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6b:	31 d2                	xor    %edx,%edx
  801b6d:	f7 f7                	div    %edi
  801b6f:	89 c5                	mov    %eax,%ebp
  801b71:	89 f0                	mov    %esi,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f5                	div    %ebp
  801b77:	89 c8                	mov    %ecx,%eax
  801b79:	f7 f5                	div    %ebp
  801b7b:	89 d0                	mov    %edx,%eax
  801b7d:	e9 44 ff ff ff       	jmp    801ac6 <__umoddi3+0x3e>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 c8                	mov    %ecx,%eax
  801b86:	89 f2                	mov    %esi,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	3b 04 24             	cmp    (%esp),%eax
  801b93:	72 06                	jb     801b9b <__umoddi3+0x113>
  801b95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b99:	77 0f                	ja     801baa <__umoddi3+0x122>
  801b9b:	89 f2                	mov    %esi,%edx
  801b9d:	29 f9                	sub    %edi,%ecx
  801b9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ba3:	89 14 24             	mov    %edx,(%esp)
  801ba6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801baa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bae:	8b 14 24             	mov    (%esp),%edx
  801bb1:	83 c4 1c             	add    $0x1c,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5f                   	pop    %edi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
  801bb9:	8d 76 00             	lea    0x0(%esi),%esi
  801bbc:	2b 04 24             	sub    (%esp),%eax
  801bbf:	19 fa                	sbb    %edi,%edx
  801bc1:	89 d1                	mov    %edx,%ecx
  801bc3:	89 c6                	mov    %eax,%esi
  801bc5:	e9 71 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd0:	72 ea                	jb     801bbc <__umoddi3+0x134>
  801bd2:	89 d9                	mov    %ebx,%ecx
  801bd4:	e9 62 ff ff ff       	jmp    801b3b <__umoddi3+0xb3>
