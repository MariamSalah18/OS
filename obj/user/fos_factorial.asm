
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 1c 80 00       	push   $0x801ca0
  800057:	e8 f1 09 00 00       	call   800a4d <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 43 0e 00 00       	call   800eb5 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 b7 1c 80 00       	push   $0x801cb7
  800097:	e8 5e 02 00 00       	call   8002fa <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000d1:	e8 6e 15 00 00       	call   801644 <sys_getenvindex>
  8000d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000dc:	89 d0                	mov    %edx,%eax
  8000de:	01 c0                	add    %eax,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	c1 e0 06             	shl    $0x6,%eax
  8000e5:	29 d0                	sub    %edx,%eax
  8000e7:	c1 e0 03             	shl    $0x3,%eax
  8000ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ef:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f9:	8a 40 68             	mov    0x68(%eax),%al
  8000fc:	84 c0                	test   %al,%al
  8000fe:	74 0d                	je     80010d <libmain+0x42>
		binaryname = myEnv->prog_name;
  800100:	a1 20 30 80 00       	mov    0x803020,%eax
  800105:	83 c0 68             	add    $0x68,%eax
  800108:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800111:	7e 0a                	jle    80011d <libmain+0x52>
		binaryname = argv[0];
  800113:	8b 45 0c             	mov    0xc(%ebp),%eax
  800116:	8b 00                	mov    (%eax),%eax
  800118:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 0c             	pushl  0xc(%ebp)
  800123:	ff 75 08             	pushl  0x8(%ebp)
  800126:	e8 0d ff ff ff       	call   800038 <_main>
  80012b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80012e:	e8 1e 13 00 00       	call   801451 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 e4 1c 80 00       	push   $0x801ce4
  80013b:	e8 8d 01 00 00       	call   8002cd <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800143:	a1 20 30 80 00       	mov    0x803020,%eax
  800148:	8b 90 dc 05 00 00    	mov    0x5dc(%eax),%edx
  80014e:	a1 20 30 80 00       	mov    0x803020,%eax
  800153:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	52                   	push   %edx
  80015d:	50                   	push   %eax
  80015e:	68 0c 1d 80 00       	push   $0x801d0c
  800163:	e8 65 01 00 00       	call   8002cd <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016b:	a1 20 30 80 00       	mov    0x803020,%eax
  800170:	8b 88 f0 05 00 00    	mov    0x5f0(%eax),%ecx
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8b 90 ec 05 00 00    	mov    0x5ec(%eax),%edx
  800181:	a1 20 30 80 00       	mov    0x803020,%eax
  800186:	8b 80 e8 05 00 00    	mov    0x5e8(%eax),%eax
  80018c:	51                   	push   %ecx
  80018d:	52                   	push   %edx
  80018e:	50                   	push   %eax
  80018f:	68 34 1d 80 00       	push   $0x801d34
  800194:	e8 34 01 00 00       	call   8002cd <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019c:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a1:	8b 80 f4 05 00 00    	mov    0x5f4(%eax),%eax
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	50                   	push   %eax
  8001ab:	68 8c 1d 80 00       	push   $0x801d8c
  8001b0:	e8 18 01 00 00       	call   8002cd <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 e4 1c 80 00       	push   $0x801ce4
  8001c0:	e8 08 01 00 00       	call   8002cd <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c8:	e8 9e 12 00 00       	call   80146b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001cd:	e8 19 00 00 00       	call   8001eb <exit>
}
  8001d2:	90                   	nop
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    

008001d5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	6a 00                	push   $0x0
  8001e0:	e8 2b 14 00 00       	call   801610 <sys_destroy_env>
  8001e5:	83 c4 10             	add    $0x10,%esp
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <exit>:

void
exit(void)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f1:	e8 80 14 00 00       	call   801676 <sys_exit_env>
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	8d 48 01             	lea    0x1(%eax),%ecx
  800207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020a:	89 0a                	mov    %ecx,(%edx)
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	88 d1                	mov    %dl,%cl
  800211:	8b 55 0c             	mov    0xc(%ebp),%edx
  800214:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	8b 00                	mov    (%eax),%eax
  80021d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800222:	75 2c                	jne    800250 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800224:	a0 24 30 80 00       	mov    0x803024,%al
  800229:	0f b6 c0             	movzbl %al,%eax
  80022c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022f:	8b 12                	mov    (%edx),%edx
  800231:	89 d1                	mov    %edx,%ecx
  800233:	8b 55 0c             	mov    0xc(%ebp),%edx
  800236:	83 c2 08             	add    $0x8,%edx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	50                   	push   %eax
  80023d:	51                   	push   %ecx
  80023e:	52                   	push   %edx
  80023f:	e8 b4 10 00 00       	call   8012f8 <sys_cputs>
  800244:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	8b 40 04             	mov    0x4(%eax),%eax
  800256:	8d 50 01             	lea    0x1(%eax),%edx
  800259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80025f:	90                   	nop
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800272:	00 00 00 
	b.cnt = 0;
  800275:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028b:	50                   	push   %eax
  80028c:	68 f9 01 80 00       	push   $0x8001f9
  800291:	e8 11 02 00 00       	call   8004a7 <vprintfmt>
  800296:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800299:	a0 24 30 80 00       	mov    0x803024,%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	50                   	push   %eax
  8002ab:	52                   	push   %edx
  8002ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b2:	83 c0 08             	add    $0x8,%eax
  8002b5:	50                   	push   %eax
  8002b6:	e8 3d 10 00 00       	call   8012f8 <sys_cputs>
  8002bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002be:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002cb:	c9                   	leave  
  8002cc:	c3                   	ret    

008002cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002d3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e9:	50                   	push   %eax
  8002ea:	e8 73 ff ff ff       	call   800262 <vcprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800300:	e8 4c 11 00 00       	call   801451 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800305:	8d 45 0c             	lea    0xc(%ebp),%eax
  800308:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	ff 75 f4             	pushl  -0xc(%ebp)
  800314:	50                   	push   %eax
  800315:	e8 48 ff ff ff       	call   800262 <vcprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800320:	e8 46 11 00 00       	call   80146b <sys_enable_interrupt>
	return cnt;
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	53                   	push   %ebx
  80032e:	83 ec 14             	sub    $0x14,%esp
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800337:	8b 45 14             	mov    0x14(%ebp),%eax
  80033a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033d:	8b 45 18             	mov    0x18(%ebp),%eax
  800340:	ba 00 00 00 00       	mov    $0x0,%edx
  800345:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800348:	77 55                	ja     80039f <printnum+0x75>
  80034a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034d:	72 05                	jb     800354 <printnum+0x2a>
  80034f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800352:	77 4b                	ja     80039f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800354:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800357:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035a:	8b 45 18             	mov    0x18(%ebp),%eax
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
  800362:	52                   	push   %edx
  800363:	50                   	push   %eax
  800364:	ff 75 f4             	pushl  -0xc(%ebp)
  800367:	ff 75 f0             	pushl  -0x10(%ebp)
  80036a:	e8 cd 16 00 00       	call   801a3c <__udivdi3>
  80036f:	83 c4 10             	add    $0x10,%esp
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	ff 75 20             	pushl  0x20(%ebp)
  800378:	53                   	push   %ebx
  800379:	ff 75 18             	pushl  0x18(%ebp)
  80037c:	52                   	push   %edx
  80037d:	50                   	push   %eax
  80037e:	ff 75 0c             	pushl  0xc(%ebp)
  800381:	ff 75 08             	pushl  0x8(%ebp)
  800384:	e8 a1 ff ff ff       	call   80032a <printnum>
  800389:	83 c4 20             	add    $0x20,%esp
  80038c:	eb 1a                	jmp    8003a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	ff 75 0c             	pushl  0xc(%ebp)
  800394:	ff 75 20             	pushl  0x20(%ebp)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	ff d0                	call   *%eax
  80039c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039f:	ff 4d 1c             	decl   0x1c(%ebp)
  8003a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a6:	7f e6                	jg     80038e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b6:	53                   	push   %ebx
  8003b7:	51                   	push   %ecx
  8003b8:	52                   	push   %edx
  8003b9:	50                   	push   %eax
  8003ba:	e8 8d 17 00 00       	call   801b4c <__umoddi3>
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  8003c7:	8a 00                	mov    (%eax),%al
  8003c9:	0f be c0             	movsbl %al,%eax
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	50                   	push   %eax
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	ff d0                	call   *%eax
  8003d8:	83 c4 10             	add    $0x10,%esp
}
  8003db:	90                   	nop
  8003dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e8:	7e 1c                	jle    800406 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	8d 50 08             	lea    0x8(%eax),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	89 10                	mov    %edx,(%eax)
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	8b 00                	mov    (%eax),%eax
  8003fc:	83 e8 08             	sub    $0x8,%eax
  8003ff:	8b 50 04             	mov    0x4(%eax),%edx
  800402:	8b 00                	mov    (%eax),%eax
  800404:	eb 40                	jmp    800446 <getuint+0x65>
	else if (lflag)
  800406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040a:	74 1e                	je     80042a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	8d 50 04             	lea    0x4(%eax),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	89 10                	mov    %edx,(%eax)
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	83 e8 04             	sub    $0x4,%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
  800428:	eb 1c                	jmp    800446 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	8d 50 04             	lea    0x4(%eax),%edx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 10                	mov    %edx,(%eax)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	83 e8 04             	sub    $0x4,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    

00800448 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044f:	7e 1c                	jle    80046d <getint+0x25>
		return va_arg(*ap, long long);
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 50 08             	lea    0x8(%eax),%edx
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	89 10                	mov    %edx,(%eax)
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	83 e8 08             	sub    $0x8,%eax
  800466:	8b 50 04             	mov    0x4(%eax),%edx
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	eb 38                	jmp    8004a5 <getint+0x5d>
	else if (lflag)
  80046d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800471:	74 1a                	je     80048d <getint+0x45>
		return va_arg(*ap, long);
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	8d 50 04             	lea    0x4(%eax),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	89 10                	mov    %edx,(%eax)
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	83 e8 04             	sub    $0x4,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	99                   	cltd   
  80048b:	eb 18                	jmp    8004a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	8d 50 04             	lea    0x4(%eax),%edx
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	89 10                	mov    %edx,(%eax)
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	83 e8 04             	sub    $0x4,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	99                   	cltd   
}
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    

008004a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	56                   	push   %esi
  8004ab:	53                   	push   %ebx
  8004ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004af:	eb 17                	jmp    8004c8 <vprintfmt+0x21>
			if (ch == '\0')
  8004b1:	85 db                	test   %ebx,%ebx
  8004b3:	0f 84 af 03 00 00    	je     800868 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 0c             	pushl  0xc(%ebp)
  8004bf:	53                   	push   %ebx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	ff d0                	call   *%eax
  8004c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cb:	8d 50 01             	lea    0x1(%eax),%edx
  8004ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d1:	8a 00                	mov    (%eax),%al
  8004d3:	0f b6 d8             	movzbl %al,%ebx
  8004d6:	83 fb 25             	cmp    $0x25,%ebx
  8004d9:	75 d6                	jne    8004b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fe:	8d 50 01             	lea    0x1(%eax),%edx
  800501:	89 55 10             	mov    %edx,0x10(%ebp)
  800504:	8a 00                	mov    (%eax),%al
  800506:	0f b6 d8             	movzbl %al,%ebx
  800509:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80050c:	83 f8 55             	cmp    $0x55,%eax
  80050f:	0f 87 2b 03 00 00    	ja     800840 <vprintfmt+0x399>
  800515:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  80051c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80051e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800522:	eb d7                	jmp    8004fb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800524:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800528:	eb d1                	jmp    8004fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800531:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800534:	89 d0                	mov    %edx,%eax
  800536:	c1 e0 02             	shl    $0x2,%eax
  800539:	01 d0                	add    %edx,%eax
  80053b:	01 c0                	add    %eax,%eax
  80053d:	01 d8                	add    %ebx,%eax
  80053f:	83 e8 30             	sub    $0x30,%eax
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800545:	8b 45 10             	mov    0x10(%ebp),%eax
  800548:	8a 00                	mov    (%eax),%al
  80054a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80054d:	83 fb 2f             	cmp    $0x2f,%ebx
  800550:	7e 3e                	jle    800590 <vprintfmt+0xe9>
  800552:	83 fb 39             	cmp    $0x39,%ebx
  800555:	7f 39                	jg     800590 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800557:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80055a:	eb d5                	jmp    800531 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	83 c0 04             	add    $0x4,%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	83 e8 04             	sub    $0x4,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800570:	eb 1f                	jmp    800591 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800572:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800576:	79 83                	jns    8004fb <vprintfmt+0x54>
				width = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80057f:	e9 77 ff ff ff       	jmp    8004fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800584:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80058b:	e9 6b ff ff ff       	jmp    8004fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800590:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800591:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800595:	0f 89 60 ff ff ff    	jns    8004fb <vprintfmt+0x54>
				width = precision, precision = -1;
  80059b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005a8:	e9 4e ff ff ff       	jmp    8004fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b0:	e9 46 ff ff ff       	jmp    8004fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 e8 04             	sub    $0x4,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	ff d0                	call   *%eax
  8005d2:	83 c4 10             	add    $0x10,%esp
			break;
  8005d5:	e9 89 02 00 00       	jmp    800863 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	83 c0 04             	add    $0x4,%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 e8 04             	sub    $0x4,%eax
  8005e9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005eb:	85 db                	test   %ebx,%ebx
  8005ed:	79 02                	jns    8005f1 <vprintfmt+0x14a>
				err = -err;
  8005ef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005f1:	83 fb 64             	cmp    $0x64,%ebx
  8005f4:	7f 0b                	jg     800601 <vprintfmt+0x15a>
  8005f6:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  8005fd:	85 f6                	test   %esi,%esi
  8005ff:	75 19                	jne    80061a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800601:	53                   	push   %ebx
  800602:	68 c5 1f 80 00       	push   $0x801fc5
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	ff 75 08             	pushl  0x8(%ebp)
  80060d:	e8 5e 02 00 00       	call   800870 <printfmt>
  800612:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800615:	e9 49 02 00 00       	jmp    800863 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061a:	56                   	push   %esi
  80061b:	68 ce 1f 80 00       	push   $0x801fce
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	e8 45 02 00 00       	call   800870 <printfmt>
  80062b:	83 c4 10             	add    $0x10,%esp
			break;
  80062e:	e9 30 02 00 00       	jmp    800863 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	83 c0 04             	add    $0x4,%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 e8 04             	sub    $0x4,%eax
  800642:	8b 30                	mov    (%eax),%esi
  800644:	85 f6                	test   %esi,%esi
  800646:	75 05                	jne    80064d <vprintfmt+0x1a6>
				p = "(null)";
  800648:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  80064d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800651:	7e 6d                	jle    8006c0 <vprintfmt+0x219>
  800653:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800657:	74 67                	je     8006c0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	50                   	push   %eax
  800660:	56                   	push   %esi
  800661:	e8 12 05 00 00       	call   800b78 <strnlen>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80066c:	eb 16                	jmp    800684 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80066e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	50                   	push   %eax
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	ff 4d e4             	decl   -0x1c(%ebp)
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	7f e4                	jg     80066e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068a:	eb 34                	jmp    8006c0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80068c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800690:	74 1c                	je     8006ae <vprintfmt+0x207>
  800692:	83 fb 1f             	cmp    $0x1f,%ebx
  800695:	7e 05                	jle    80069c <vprintfmt+0x1f5>
  800697:	83 fb 7e             	cmp    $0x7e,%ebx
  80069a:	7e 12                	jle    8006ae <vprintfmt+0x207>
					putch('?', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	6a 3f                	push   $0x3f
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	eb 0f                	jmp    8006bd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	53                   	push   %ebx
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	ff d0                	call   *%eax
  8006ba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c0:	89 f0                	mov    %esi,%eax
  8006c2:	8d 70 01             	lea    0x1(%eax),%esi
  8006c5:	8a 00                	mov    (%eax),%al
  8006c7:	0f be d8             	movsbl %al,%ebx
  8006ca:	85 db                	test   %ebx,%ebx
  8006cc:	74 24                	je     8006f2 <vprintfmt+0x24b>
  8006ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d2:	78 b8                	js     80068c <vprintfmt+0x1e5>
  8006d4:	ff 4d e0             	decl   -0x20(%ebp)
  8006d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006db:	79 af                	jns    80068c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006dd:	eb 13                	jmp    8006f2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	6a 20                	push   $0x20
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	ff d0                	call   *%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f6:	7f e7                	jg     8006df <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006f8:	e9 66 01 00 00       	jmp    800863 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 e8             	pushl  -0x18(%ebp)
  800703:	8d 45 14             	lea    0x14(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	e8 3c fd ff ff       	call   800448 <getint>
  80070c:	83 c4 10             	add    $0x10,%esp
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	85 d2                	test   %edx,%edx
  80071d:	79 23                	jns    800742 <vprintfmt+0x29b>
				putch('-', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 2d                	push   $0x2d
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80072f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800735:	f7 d8                	neg    %eax
  800737:	83 d2 00             	adc    $0x0,%edx
  80073a:	f7 da                	neg    %edx
  80073c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800742:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800749:	e9 bc 00 00 00       	jmp    80080a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 e8             	pushl  -0x18(%ebp)
  800754:	8d 45 14             	lea    0x14(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	e8 84 fc ff ff       	call   8003e1 <getuint>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800763:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800766:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076d:	e9 98 00 00 00       	jmp    80080a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 58                	push   $0x58
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	6a 58                	push   $0x58
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	6a 58                	push   $0x58
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	ff d0                	call   *%eax
  80079f:	83 c4 10             	add    $0x10,%esp
			break;
  8007a2:	e9 bc 00 00 00       	jmp    800863 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	6a 30                	push   $0x30
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	ff 75 0c             	pushl  0xc(%ebp)
  8007bd:	6a 78                	push   $0x78
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	83 c0 04             	add    $0x4,%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007e2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007e9:	eb 1f                	jmp    80080a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	e8 e7 fb ff ff       	call   8003e1 <getuint>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800800:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800803:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80080e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	52                   	push   %edx
  800815:	ff 75 e4             	pushl  -0x1c(%ebp)
  800818:	50                   	push   %eax
  800819:	ff 75 f4             	pushl  -0xc(%ebp)
  80081c:	ff 75 f0             	pushl  -0x10(%ebp)
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 08             	pushl  0x8(%ebp)
  800825:	e8 00 fb ff ff       	call   80032a <printnum>
  80082a:	83 c4 20             	add    $0x20,%esp
			break;
  80082d:	eb 34                	jmp    800863 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	53                   	push   %ebx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	eb 23                	jmp    800863 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 25                	push   $0x25
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800850:	ff 4d 10             	decl   0x10(%ebp)
  800853:	eb 03                	jmp    800858 <vprintfmt+0x3b1>
  800855:	ff 4d 10             	decl   0x10(%ebp)
  800858:	8b 45 10             	mov    0x10(%ebp),%eax
  80085b:	48                   	dec    %eax
  80085c:	8a 00                	mov    (%eax),%al
  80085e:	3c 25                	cmp    $0x25,%al
  800860:	75 f3                	jne    800855 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800862:	90                   	nop
		}
	}
  800863:	e9 47 fc ff ff       	jmp    8004af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800868:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800876:	8d 45 10             	lea    0x10(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	ff 75 f4             	pushl  -0xc(%ebp)
  800885:	50                   	push   %eax
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 16 fc ff ff       	call   8004a7 <vprintfmt>
  800891:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800894:	90                   	nop
  800895:	c9                   	leave  
  800896:	c3                   	ret    

00800897 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089d:	8b 40 08             	mov    0x8(%eax),%eax
  8008a0:	8d 50 01             	lea    0x1(%eax),%edx
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ac:	8b 10                	mov    (%eax),%edx
  8008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b1:	8b 40 04             	mov    0x4(%eax),%eax
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	73 12                	jae    8008ca <sprintputch+0x33>
		*b->buf++ = ch;
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c3:	89 0a                	mov    %ecx,(%edx)
  8008c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c8:	88 10                	mov    %dl,(%eax)
}
  8008ca:	90                   	nop
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f2:	74 06                	je     8008fa <vsnprintf+0x2d>
  8008f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f8:	7f 07                	jg     800901 <vsnprintf+0x34>
		return -E_INVAL;
  8008fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ff:	eb 20                	jmp    800921 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800901:	ff 75 14             	pushl  0x14(%ebp)
  800904:	ff 75 10             	pushl  0x10(%ebp)
  800907:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090a:	50                   	push   %eax
  80090b:	68 97 08 80 00       	push   $0x800897
  800910:	e8 92 fb ff ff       	call   8004a7 <vprintfmt>
  800915:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80091e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800921:	c9                   	leave  
  800922:	c3                   	ret    

00800923 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800929:	8d 45 10             	lea    0x10(%ebp),%eax
  80092c:	83 c0 04             	add    $0x4,%eax
  80092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	ff 75 f4             	pushl  -0xc(%ebp)
  800938:	50                   	push   %eax
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	e8 89 ff ff ff       	call   8008cd <vsnprintf>
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80094a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800955:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800959:	74 13                	je     80096e <readline+0x1f>
		cprintf("%s", prompt);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	68 30 21 80 00       	push   $0x802130
  800966:	e8 62 f9 ff ff       	call   8002cd <cprintf>
  80096b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80096e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800975:	83 ec 0c             	sub    $0xc,%esp
  800978:	6a 00                	push   $0x0
  80097a:	e8 b2 10 00 00       	call   801a31 <iscons>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800985:	e8 59 10 00 00       	call   8019e3 <getchar>
  80098a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80098d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800991:	79 22                	jns    8009b5 <readline+0x66>
			if (c != -E_EOF)
  800993:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800997:	0f 84 ad 00 00 00    	je     800a4a <readline+0xfb>
				cprintf("read error: %e\n", c);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8009a3:	68 33 21 80 00       	push   $0x802133
  8009a8:	e8 20 f9 ff ff       	call   8002cd <cprintf>
  8009ad:	83 c4 10             	add    $0x10,%esp
			return;
  8009b0:	e9 95 00 00 00       	jmp    800a4a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009b5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009b9:	7e 34                	jle    8009ef <readline+0xa0>
  8009bb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009c2:	7f 2b                	jg     8009ef <readline+0xa0>
			if (echoing)
  8009c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009c8:	74 0e                	je     8009d8 <readline+0x89>
				cputchar(c);
  8009ca:	83 ec 0c             	sub    $0xc,%esp
  8009cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8009d0:	e8 c6 0f 00 00       	call   80199b <cputchar>
  8009d5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009db:	8d 50 01             	lea    0x1(%eax),%edx
  8009de:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	01 d0                	add    %edx,%eax
  8009e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009eb:	88 10                	mov    %dl,(%eax)
  8009ed:	eb 56                	jmp    800a45 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8009ef:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8009f3:	75 1f                	jne    800a14 <readline+0xc5>
  8009f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8009f9:	7e 19                	jle    800a14 <readline+0xc5>
			if (echoing)
  8009fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009ff:	74 0e                	je     800a0f <readline+0xc0>
				cputchar(c);
  800a01:	83 ec 0c             	sub    $0xc,%esp
  800a04:	ff 75 ec             	pushl  -0x14(%ebp)
  800a07:	e8 8f 0f 00 00       	call   80199b <cputchar>
  800a0c:	83 c4 10             	add    $0x10,%esp

			i--;
  800a0f:	ff 4d f4             	decl   -0xc(%ebp)
  800a12:	eb 31                	jmp    800a45 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a14:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a18:	74 0a                	je     800a24 <readline+0xd5>
  800a1a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a1e:	0f 85 61 ff ff ff    	jne    800985 <readline+0x36>
			if (echoing)
  800a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a28:	74 0e                	je     800a38 <readline+0xe9>
				cputchar(c);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a30:	e8 66 0f 00 00       	call   80199b <cputchar>
  800a35:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a43:	eb 06                	jmp    800a4b <readline+0xfc>
		}
	}
  800a45:	e9 3b ff ff ff       	jmp    800985 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a4a:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a53:	e8 f9 09 00 00       	call   801451 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a5c:	74 13                	je     800a71 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 08             	pushl  0x8(%ebp)
  800a64:	68 30 21 80 00       	push   $0x802130
  800a69:	e8 5f f8 ff ff       	call   8002cd <cprintf>
  800a6e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a78:	83 ec 0c             	sub    $0xc,%esp
  800a7b:	6a 00                	push   $0x0
  800a7d:	e8 af 0f 00 00       	call   801a31 <iscons>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a88:	e8 56 0f 00 00       	call   8019e3 <getchar>
  800a8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a94:	79 23                	jns    800ab9 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800a96:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a9a:	74 13                	je     800aaf <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 ec             	pushl  -0x14(%ebp)
  800aa2:	68 33 21 80 00       	push   $0x802133
  800aa7:	e8 21 f8 ff ff       	call   8002cd <cprintf>
  800aac:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800aaf:	e8 b7 09 00 00       	call   80146b <sys_enable_interrupt>
			return;
  800ab4:	e9 9a 00 00 00       	jmp    800b53 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ab9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800abd:	7e 34                	jle    800af3 <atomic_readline+0xa6>
  800abf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ac6:	7f 2b                	jg     800af3 <atomic_readline+0xa6>
			if (echoing)
  800ac8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800acc:	74 0e                	je     800adc <atomic_readline+0x8f>
				cputchar(c);
  800ace:	83 ec 0c             	sub    $0xc,%esp
  800ad1:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad4:	e8 c2 0e 00 00       	call   80199b <cputchar>
  800ad9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800adf:	8d 50 01             	lea    0x1(%eax),%edx
  800ae2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	01 d0                	add    %edx,%eax
  800aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aef:	88 10                	mov    %dl,(%eax)
  800af1:	eb 5b                	jmp    800b4e <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800af3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800af7:	75 1f                	jne    800b18 <atomic_readline+0xcb>
  800af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800afd:	7e 19                	jle    800b18 <atomic_readline+0xcb>
			if (echoing)
  800aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b03:	74 0e                	je     800b13 <atomic_readline+0xc6>
				cputchar(c);
  800b05:	83 ec 0c             	sub    $0xc,%esp
  800b08:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0b:	e8 8b 0e 00 00       	call   80199b <cputchar>
  800b10:	83 c4 10             	add    $0x10,%esp
			i--;
  800b13:	ff 4d f4             	decl   -0xc(%ebp)
  800b16:	eb 36                	jmp    800b4e <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b18:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b1c:	74 0a                	je     800b28 <atomic_readline+0xdb>
  800b1e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b22:	0f 85 60 ff ff ff    	jne    800a88 <atomic_readline+0x3b>
			if (echoing)
  800b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2c:	74 0e                	je     800b3c <atomic_readline+0xef>
				cputchar(c);
  800b2e:	83 ec 0c             	sub    $0xc,%esp
  800b31:	ff 75 ec             	pushl  -0x14(%ebp)
  800b34:	e8 62 0e 00 00       	call   80199b <cputchar>
  800b39:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	01 d0                	add    %edx,%eax
  800b44:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b47:	e8 1f 09 00 00       	call   80146b <sys_enable_interrupt>
			return;
  800b4c:	eb 05                	jmp    800b53 <atomic_readline+0x106>
		}
	}
  800b4e:	e9 35 ff ff ff       	jmp    800a88 <atomic_readline+0x3b>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b62:	eb 06                	jmp    800b6a <strlen+0x15>
		n++;
  800b64:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b67:	ff 45 08             	incl   0x8(%ebp)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	84 c0                	test   %al,%al
  800b71:	75 f1                	jne    800b64 <strlen+0xf>
		n++;
	return n;
  800b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b85:	eb 09                	jmp    800b90 <strnlen+0x18>
		n++;
  800b87:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8a:	ff 45 08             	incl   0x8(%ebp)
  800b8d:	ff 4d 0c             	decl   0xc(%ebp)
  800b90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b94:	74 09                	je     800b9f <strnlen+0x27>
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	84 c0                	test   %al,%al
  800b9d:	75 e8                	jne    800b87 <strnlen+0xf>
		n++;
	return n;
  800b9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bb0:	90                   	nop
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc3:	8a 12                	mov    (%edx),%dl
  800bc5:	88 10                	mov    %dl,(%eax)
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	84 c0                	test   %al,%al
  800bcb:	75 e4                	jne    800bb1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 1f                	jmp    800c06 <strncpy+0x34>
		*dst++ = *src;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8d 50 01             	lea    0x1(%eax),%edx
  800bed:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf3:	8a 12                	mov    (%edx),%dl
  800bf5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	84 c0                	test   %al,%al
  800bfe:	74 03                	je     800c03 <strncpy+0x31>
			src++;
  800c00:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c03:	ff 45 fc             	incl   -0x4(%ebp)
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c09:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c0c:	72 d9                	jb     800be7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c23:	74 30                	je     800c55 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c25:	eb 16                	jmp    800c3d <strlcpy+0x2a>
			*dst++ = *src++;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8d 50 01             	lea    0x1(%eax),%edx
  800c2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c39:	8a 12                	mov    (%edx),%dl
  800c3b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c3d:	ff 4d 10             	decl   0x10(%ebp)
  800c40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c44:	74 09                	je     800c4f <strlcpy+0x3c>
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 d8                	jne    800c27 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c55:	8b 55 08             	mov    0x8(%ebp),%edx
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	29 c2                	sub    %eax,%edx
  800c5d:	89 d0                	mov    %edx,%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c64:	eb 06                	jmp    800c6c <strcmp+0xb>
		p++, q++;
  800c66:	ff 45 08             	incl   0x8(%ebp)
  800c69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	74 0e                	je     800c83 <strcmp+0x22>
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 10                	mov    (%eax),%dl
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	38 c2                	cmp    %al,%dl
  800c81:	74 e3                	je     800c66 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d0             	movzbl %al,%edx
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	0f b6 c0             	movzbl %al,%eax
  800c93:	29 c2                	sub    %eax,%edx
  800c95:	89 d0                	mov    %edx,%eax
}
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c9c:	eb 09                	jmp    800ca7 <strncmp+0xe>
		n--, p++, q++;
  800c9e:	ff 4d 10             	decl   0x10(%ebp)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cab:	74 17                	je     800cc4 <strncmp+0x2b>
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	84 c0                	test   %al,%al
  800cb4:	74 0e                	je     800cc4 <strncmp+0x2b>
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 10                	mov    (%eax),%dl
  800cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	38 c2                	cmp    %al,%dl
  800cc2:	74 da                	je     800c9e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc8:	75 07                	jne    800cd1 <strncmp+0x38>
		return 0;
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	eb 14                	jmp    800ce5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 d0             	movzbl %al,%edx
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	0f b6 c0             	movzbl %al,%eax
  800ce1:	29 c2                	sub    %eax,%edx
  800ce3:	89 d0                	mov    %edx,%eax
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cf3:	eb 12                	jmp    800d07 <strchr+0x20>
		if (*s == c)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cfd:	75 05                	jne    800d04 <strchr+0x1d>
			return (char *) s;
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	eb 11                	jmp    800d15 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e5                	jne    800cf5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	83 ec 04             	sub    $0x4,%esp
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d23:	eb 0d                	jmp    800d32 <strfind+0x1b>
		if (*s == c)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2d:	74 0e                	je     800d3d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d2f:	ff 45 08             	incl   0x8(%ebp)
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	84 c0                	test   %al,%al
  800d39:	75 ea                	jne    800d25 <strfind+0xe>
  800d3b:	eb 01                	jmp    800d3e <strfind+0x27>
		if (*s == c)
			break;
  800d3d:	90                   	nop
	return (char *) s;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d55:	eb 0e                	jmp    800d65 <memset+0x22>
		*p++ = c;
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5a:	8d 50 01             	lea    0x1(%eax),%edx
  800d5d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d63:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d65:	ff 4d f8             	decl   -0x8(%ebp)
  800d68:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d6c:	79 e9                	jns    800d57 <memset+0x14>
		*p++ = c;

	return v;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d85:	eb 16                	jmp    800d9d <memcpy+0x2a>
		*d++ = *s++;
  800d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d99:	8a 12                	mov    (%edx),%dl
  800d9b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da3:	89 55 10             	mov    %edx,0x10(%ebp)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	75 dd                	jne    800d87 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc7:	73 50                	jae    800e19 <memmove+0x6a>
  800dc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd4:	76 43                	jbe    800e19 <memmove+0x6a>
		s += n;
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800de2:	eb 10                	jmp    800df4 <memmove+0x45>
			*--d = *--s;
  800de4:	ff 4d f8             	decl   -0x8(%ebp)
  800de7:	ff 4d fc             	decl   -0x4(%ebp)
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8a 10                	mov    (%eax),%dl
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	75 e3                	jne    800de4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e01:	eb 23                	jmp    800e26 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e06:	8d 50 01             	lea    0x1(%eax),%edx
  800e09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e12:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e15:	8a 12                	mov    (%edx),%dl
  800e17:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	75 dd                	jne    800e03 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e3d:	eb 2a                	jmp    800e69 <memcmp+0x3e>
		if (*s1 != *s2)
  800e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e42:	8a 10                	mov    (%eax),%dl
  800e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	38 c2                	cmp    %al,%dl
  800e4b:	74 16                	je     800e63 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	0f b6 d0             	movzbl %al,%edx
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 c0             	movzbl %al,%eax
  800e5d:	29 c2                	sub    %eax,%edx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	eb 18                	jmp    800e7b <memcmp+0x50>
		s1++, s2++;
  800e63:	ff 45 fc             	incl   -0x4(%ebp)
  800e66:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	75 c9                	jne    800e3f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 45 10             	mov    0x10(%ebp),%eax
  800e89:	01 d0                	add    %edx,%eax
  800e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e8e:	eb 15                	jmp    800ea5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	0f b6 d0             	movzbl %al,%edx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	0f b6 c0             	movzbl %al,%eax
  800e9e:	39 c2                	cmp    %eax,%edx
  800ea0:	74 0d                	je     800eaf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ea2:	ff 45 08             	incl   0x8(%ebp)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eab:	72 e3                	jb     800e90 <memfind+0x13>
  800ead:	eb 01                	jmp    800eb0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eaf:	90                   	nop
	return (void *) s;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ec2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec9:	eb 03                	jmp    800ece <strtol+0x19>
		s++;
  800ecb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	3c 20                	cmp    $0x20,%al
  800ed5:	74 f4                	je     800ecb <strtol+0x16>
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	3c 09                	cmp    $0x9,%al
  800ede:	74 eb                	je     800ecb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 2b                	cmp    $0x2b,%al
  800ee7:	75 05                	jne    800eee <strtol+0x39>
		s++;
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	eb 13                	jmp    800f01 <strtol+0x4c>
	else if (*s == '-')
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 2d                	cmp    $0x2d,%al
  800ef5:	75 0a                	jne    800f01 <strtol+0x4c>
		s++, neg = 1;
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f05:	74 06                	je     800f0d <strtol+0x58>
  800f07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f0b:	75 20                	jne    800f2d <strtol+0x78>
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 30                	cmp    $0x30,%al
  800f14:	75 17                	jne    800f2d <strtol+0x78>
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	40                   	inc    %eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3c 78                	cmp    $0x78,%al
  800f1e:	75 0d                	jne    800f2d <strtol+0x78>
		s += 2, base = 16;
  800f20:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f24:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f2b:	eb 28                	jmp    800f55 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f31:	75 15                	jne    800f48 <strtol+0x93>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 30                	cmp    $0x30,%al
  800f3a:	75 0c                	jne    800f48 <strtol+0x93>
		s++, base = 8;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
  800f3f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f46:	eb 0d                	jmp    800f55 <strtol+0xa0>
	else if (base == 0)
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	75 07                	jne    800f55 <strtol+0xa0>
		base = 10;
  800f4e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 2f                	cmp    $0x2f,%al
  800f5c:	7e 19                	jle    800f77 <strtol+0xc2>
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 39                	cmp    $0x39,%al
  800f65:	7f 10                	jg     800f77 <strtol+0xc2>
			dig = *s - '0';
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	0f be c0             	movsbl %al,%eax
  800f6f:	83 e8 30             	sub    $0x30,%eax
  800f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f75:	eb 42                	jmp    800fb9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 60                	cmp    $0x60,%al
  800f7e:	7e 19                	jle    800f99 <strtol+0xe4>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 7a                	cmp    $0x7a,%al
  800f87:	7f 10                	jg     800f99 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	0f be c0             	movsbl %al,%eax
  800f91:	83 e8 57             	sub    $0x57,%eax
  800f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f97:	eb 20                	jmp    800fb9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 40                	cmp    $0x40,%al
  800fa0:	7e 39                	jle    800fdb <strtol+0x126>
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 5a                	cmp    $0x5a,%al
  800fa9:	7f 30                	jg     800fdb <strtol+0x126>
			dig = *s - 'A' + 10;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f be c0             	movsbl %al,%eax
  800fb3:	83 e8 37             	sub    $0x37,%eax
  800fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fbf:	7d 19                	jge    800fda <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fcb:	89 c2                	mov    %eax,%edx
  800fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd5:	e9 7b ff ff ff       	jmp    800f55 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fda:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fdf:	74 08                	je     800fe9 <strtol+0x134>
		*endptr = (char *) s;
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fed:	74 07                	je     800ff6 <strtol+0x141>
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	f7 d8                	neg    %eax
  800ff4:	eb 03                	jmp    800ff9 <strtol+0x144>
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <ltostr>:

void
ltostr(long value, char *str)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801008:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80100f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801013:	79 13                	jns    801028 <ltostr+0x2d>
	{
		neg = 1;
  801015:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801022:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801025:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801030:	99                   	cltd   
  801031:	f7 f9                	idiv   %ecx
  801033:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	8d 50 01             	lea    0x1(%eax),%edx
  80103c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103f:	89 c2                	mov    %eax,%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801049:	83 c2 30             	add    $0x30,%edx
  80104c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80104e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801051:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801056:	f7 e9                	imul   %ecx
  801058:	c1 fa 02             	sar    $0x2,%edx
  80105b:	89 c8                	mov    %ecx,%eax
  80105d:	c1 f8 1f             	sar    $0x1f,%eax
  801060:	29 c2                	sub    %eax,%edx
  801062:	89 d0                	mov    %edx,%eax
  801064:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801067:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80106f:	f7 e9                	imul   %ecx
  801071:	c1 fa 02             	sar    $0x2,%edx
  801074:	89 c8                	mov    %ecx,%eax
  801076:	c1 f8 1f             	sar    $0x1f,%eax
  801079:	29 c2                	sub    %eax,%edx
  80107b:	89 d0                	mov    %edx,%eax
  80107d:	c1 e0 02             	shl    $0x2,%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	01 c0                	add    %eax,%eax
  801084:	29 c1                	sub    %eax,%ecx
  801086:	89 ca                	mov    %ecx,%edx
  801088:	85 d2                	test   %edx,%edx
  80108a:	75 9c                	jne    801028 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80108c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801096:	48                   	dec    %eax
  801097:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80109a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109e:	74 3d                	je     8010dd <ltostr+0xe2>
		start = 1 ;
  8010a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010a7:	eb 34                	jmp    8010dd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	01 c2                	add    %eax,%edx
  8010be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	01 c8                	add    %ecx,%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 c2                	add    %eax,%edx
  8010d2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010d5:	88 02                	mov    %al,(%edx)
		start++ ;
  8010d7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010da:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010e3:	7c c4                	jl     8010a9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010f0:	90                   	nop
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	e8 54 fa ff ff       	call   800b55 <strlen>
  801101:	83 c4 04             	add    $0x4,%esp
  801104:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	e8 46 fa ff ff       	call   800b55 <strlen>
  80110f:	83 c4 04             	add    $0x4,%esp
  801112:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801115:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80111c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801123:	eb 17                	jmp    80113c <strcconcat+0x49>
		final[s] = str1[s] ;
  801125:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 c2                	add    %eax,%edx
  80112d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	01 c8                	add    %ecx,%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801139:	ff 45 fc             	incl   -0x4(%ebp)
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801142:	7c e1                	jl     801125 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801144:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80114b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801152:	eb 1f                	jmp    801173 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801157:	8d 50 01             	lea    0x1(%eax),%edx
  80115a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 c2                	add    %eax,%edx
  801164:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	01 c8                	add    %ecx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801170:	ff 45 f8             	incl   -0x8(%ebp)
  801173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801176:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801179:	7c d9                	jl     801154 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80117b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	c6 00 00             	movb   $0x0,(%eax)
}
  801186:	90                   	nop
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80118c:	8b 45 14             	mov    0x14(%ebp),%eax
  80118f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801195:	8b 45 14             	mov    0x14(%ebp),%eax
  801198:	8b 00                	mov    (%eax),%eax
  80119a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ac:	eb 0c                	jmp    8011ba <strsplit+0x31>
			*string++ = 0;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	84 c0                	test   %al,%al
  8011c1:	74 18                	je     8011db <strsplit+0x52>
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	0f be c0             	movsbl %al,%eax
  8011cb:	50                   	push   %eax
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	e8 13 fb ff ff       	call   800ce7 <strchr>
  8011d4:	83 c4 08             	add    $0x8,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	75 d3                	jne    8011ae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 5a                	je     80123e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	8b 00                	mov    (%eax),%eax
  8011e9:	83 f8 0f             	cmp    $0xf,%eax
  8011ec:	75 07                	jne    8011f5 <strsplit+0x6c>
		{
			return 0;
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f3:	eb 66                	jmp    80125b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8011fd:	8b 55 14             	mov    0x14(%ebp),%edx
  801200:	89 0a                	mov    %ecx,(%edx)
  801202:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	01 c2                	add    %eax,%edx
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801213:	eb 03                	jmp    801218 <strsplit+0x8f>
			string++;
  801215:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	84 c0                	test   %al,%al
  80121f:	74 8b                	je     8011ac <strsplit+0x23>
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	0f be c0             	movsbl %al,%eax
  801229:	50                   	push   %eax
  80122a:	ff 75 0c             	pushl  0xc(%ebp)
  80122d:	e8 b5 fa ff ff       	call   800ce7 <strchr>
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	74 dc                	je     801215 <strsplit+0x8c>
			string++;
	}
  801239:	e9 6e ff ff ff       	jmp    8011ac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80123e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	8b 00                	mov    (%eax),%eax
  801244:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 d0                	add    %edx,%eax
  801250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801256:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  801263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126a:	eb 4c                	jmp    8012b8 <str2lower+0x5b>
	{
		if(src[i]>= 65 && src[i]<=90)
  80126c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 40                	cmp    $0x40,%al
  801278:	7e 27                	jle    8012a1 <str2lower+0x44>
  80127a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 5a                	cmp    $0x5a,%al
  801286:	7f 19                	jg     8012a1 <str2lower+0x44>
		{
			dst[i]=src[i]+32;
  801288:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801293:	8b 55 0c             	mov    0xc(%ebp),%edx
  801296:	01 ca                	add    %ecx,%edx
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	83 c2 20             	add    $0x20,%edx
  80129d:	88 10                	mov    %dl,(%eax)
  80129f:	eb 14                	jmp    8012b5 <str2lower+0x58>
		}
		else
		{
			dst[i]=src[i];
  8012a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	01 c2                	add    %eax,%edx
  8012a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");

	for(int i =0; i<strlen(src); i++)
  8012b5:	ff 45 fc             	incl   -0x4(%ebp)
  8012b8:	ff 75 0c             	pushl  0xc(%ebp)
  8012bb:	e8 95 f8 ff ff       	call   800b55 <strlen>
  8012c0:	83 c4 04             	add    $0x4,%esp
  8012c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012c6:	7f a4                	jg     80126c <str2lower+0xf>
		{
			dst[i]=src[i];
		}

	}
	return dst;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	57                   	push   %edi
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
  8012d3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012e5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e8:	cd 30                	int    $0x30
  8012ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5e                   	pop    %esi
  8012f5:	5f                   	pop    %edi
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801304:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	52                   	push   %edx
  801310:	ff 75 0c             	pushl  0xc(%ebp)
  801313:	50                   	push   %eax
  801314:	6a 00                	push   $0x0
  801316:	e8 b2 ff ff ff       	call   8012cd <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <sys_cgetc>:

int
sys_cgetc(void)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 01                	push   $0x1
  801330:	e8 98 ff ff ff       	call   8012cd <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	52                   	push   %edx
  80134a:	50                   	push   %eax
  80134b:	6a 05                	push   $0x5
  80134d:	e8 7b ff ff ff       	call   8012cd <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80135c:	8b 75 18             	mov    0x18(%ebp),%esi
  80135f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801362:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801365:	8b 55 0c             	mov    0xc(%ebp),%edx
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	56                   	push   %esi
  80136c:	53                   	push   %ebx
  80136d:	51                   	push   %ecx
  80136e:	52                   	push   %edx
  80136f:	50                   	push   %eax
  801370:	6a 06                	push   $0x6
  801372:	e8 56 ff ff ff       	call   8012cd <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    

00801381 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801384:	8b 55 0c             	mov    0xc(%ebp),%edx
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	52                   	push   %edx
  801391:	50                   	push   %eax
  801392:	6a 07                	push   $0x7
  801394:	e8 34 ff ff ff       	call   8012cd <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	6a 08                	push   $0x8
  8013af:	e8 19 ff ff ff       	call   8012cd <syscall>
  8013b4:	83 c4 18             	add    $0x18,%esp
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 09                	push   $0x9
  8013c8:	e8 00 ff ff ff       	call   8012cd <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 0a                	push   $0xa
  8013e1:	e8 e7 fe ff ff       	call   8012cd <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 0b                	push   $0xb
  8013fa:	e8 ce fe ff ff       	call   8012cd <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 0c                	push   $0xc
  801413:	e8 b5 fe ff ff       	call   8012cd <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	ff 75 08             	pushl  0x8(%ebp)
  80142b:	6a 0d                	push   $0xd
  80142d:	e8 9b fe ff ff       	call   8012cd <syscall>
  801432:	83 c4 18             	add    $0x18,%esp
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 0e                	push   $0xe
  801446:	e8 82 fe ff ff       	call   8012cd <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
}
  80144e:	90                   	nop
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 11                	push   $0x11
  801460:	e8 68 fe ff ff       	call   8012cd <syscall>
  801465:	83 c4 18             	add    $0x18,%esp
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 12                	push   $0x12
  80147a:	e8 4e fe ff ff       	call   8012cd <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	90                   	nop
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_cputc>:


void
sys_cputc(const char c)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801491:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	50                   	push   %eax
  80149e:	6a 13                	push   $0x13
  8014a0:	e8 28 fe ff ff       	call   8012cd <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 14                	push   $0x14
  8014ba:	e8 0e fe ff ff       	call   8012cd <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	90                   	nop
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	6a 15                	push   $0x15
  8014d7:	e8 f1 fd ff ff       	call   8012cd <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	52                   	push   %edx
  8014f1:	50                   	push   %eax
  8014f2:	6a 18                	push   $0x18
  8014f4:	e8 d4 fd ff ff       	call   8012cd <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801501:	8b 55 0c             	mov    0xc(%ebp),%edx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	6a 16                	push   $0x16
  801511:	e8 b7 fd ff ff       	call   8012cd <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	90                   	nop
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80151f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	52                   	push   %edx
  80152c:	50                   	push   %eax
  80152d:	6a 17                	push   $0x17
  80152f:	e8 99 fd ff ff       	call   8012cd <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	90                   	nop
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	8b 45 10             	mov    0x10(%ebp),%eax
  801543:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801546:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801549:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	6a 00                	push   $0x0
  801552:	51                   	push   %ecx
  801553:	52                   	push   %edx
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	50                   	push   %eax
  801558:	6a 19                	push   $0x19
  80155a:	e8 6e fd ff ff       	call   8012cd <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	52                   	push   %edx
  801574:	50                   	push   %eax
  801575:	6a 1a                	push   $0x1a
  801577:	e8 51 fd ff ff       	call   8012cd <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801584:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	51                   	push   %ecx
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 1b                	push   $0x1b
  801596:	e8 32 fd ff ff       	call   8012cd <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 1c                	push   $0x1c
  8015b3:	e8 15 fd ff ff       	call   8012cd <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 1d                	push   $0x1d
  8015cc:	e8 fc fc ff ff       	call   8012cd <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	6a 00                	push   $0x0
  8015de:	ff 75 14             	pushl  0x14(%ebp)
  8015e1:	ff 75 10             	pushl  0x10(%ebp)
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	50                   	push   %eax
  8015e8:	6a 1e                	push   $0x1e
  8015ea:	e8 de fc ff ff       	call   8012cd <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	50                   	push   %eax
  801603:	6a 1f                	push   $0x1f
  801605:	e8 c3 fc ff ff       	call   8012cd <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	50                   	push   %eax
  80161f:	6a 20                	push   $0x20
  801621:	e8 a7 fc ff ff       	call   8012cd <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 02                	push   $0x2
  80163a:	e8 8e fc ff ff       	call   8012cd <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 03                	push   $0x3
  801653:	e8 75 fc ff ff       	call   8012cd <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 04                	push   $0x4
  80166c:	e8 5c fc ff ff       	call   8012cd <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_exit_env>:


void sys_exit_env(void)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 21                	push   $0x21
  801685:	e8 43 fc ff ff       	call   8012cd <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801696:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801699:	8d 50 04             	lea    0x4(%eax),%edx
  80169c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 22                	push   $0x22
  8016a9:	e8 1f fc ff ff       	call   8012cd <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
	return result;
  8016b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ba:	89 01                	mov    %eax,(%ecx)
  8016bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	c9                   	leave  
  8016c3:	c2 04 00             	ret    $0x4

008016c6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	ff 75 10             	pushl  0x10(%ebp)
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	6a 10                	push   $0x10
  8016d8:	e8 f0 fb ff ff       	call   8012cd <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e0:	90                   	nop
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 23                	push   $0x23
  8016f2:	e8 d6 fb ff ff       	call   8012cd <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801708:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	50                   	push   %eax
  801715:	6a 24                	push   $0x24
  801717:	e8 b1 fb ff ff       	call   8012cd <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
	return ;
  80171f:	90                   	nop
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <rsttst>:
void rsttst()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 26                	push   $0x26
  801731:	e8 97 fb ff ff       	call   8012cd <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
	return ;
  801739:	90                   	nop
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 14             	mov    0x14(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801748:	8b 55 18             	mov    0x18(%ebp),%edx
  80174b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80174f:	52                   	push   %edx
  801750:	50                   	push   %eax
  801751:	ff 75 10             	pushl  0x10(%ebp)
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 25                	push   $0x25
  80175c:	e8 6c fb ff ff       	call   8012cd <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
	return ;
  801764:	90                   	nop
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <chktst>:
void chktst(uint32 n)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	6a 27                	push   $0x27
  801777:	e8 51 fb ff ff       	call   8012cd <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
	return ;
  80177f:	90                   	nop
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <inctst>:

void inctst()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 28                	push   $0x28
  801791:	e8 37 fb ff ff       	call   8012cd <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <gettst>:
uint32 gettst()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 29                	push   $0x29
  8017ab:	e8 1d fb ff ff       	call   8012cd <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 2a                	push   $0x2a
  8017c7:	e8 01 fb ff ff       	call   8012cd <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
  8017cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017d2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017d6:	75 07                	jne    8017df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017dd:	eb 05                	jmp    8017e4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 2a                	push   $0x2a
  8017f8:	e8 d0 fa ff ff       	call   8012cd <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
  801800:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801803:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801807:	75 07                	jne    801810 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801809:	b8 01 00 00 00       	mov    $0x1,%eax
  80180e:	eb 05                	jmp    801815 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 2a                	push   $0x2a
  801829:	e8 9f fa ff ff       	call   8012cd <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
  801831:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801834:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801838:	75 07                	jne    801841 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80183a:	b8 01 00 00 00       	mov    $0x1,%eax
  80183f:	eb 05                	jmp    801846 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 2a                	push   $0x2a
  80185a:	e8 6e fa ff ff       	call   8012cd <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
  801862:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801865:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801869:	75 07                	jne    801872 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80186b:	b8 01 00 00 00       	mov    $0x1,%eax
  801870:	eb 05                	jmp    801877 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 2b                	push   $0x2b
  801889:	e8 3f fa ff ff       	call   8012cd <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801898:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	53                   	push   %ebx
  8018a7:	51                   	push   %ecx
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 2c                	push   $0x2c
  8018ac:	e8 1c fa ff ff       	call   8012cd <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 2d                	push   $0x2d
  8018cc:	e8 fc f9 ff ff       	call   8012cd <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	51                   	push   %ecx
  8018e5:	ff 75 10             	pushl  0x10(%ebp)
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 2e                	push   $0x2e
  8018ec:	e8 dc f9 ff ff       	call   8012cd <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 10             	pushl  0x10(%ebp)
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 0f                	push   $0xf
  801908:	e8 c0 f9 ff ff       	call   8012cd <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return ;
  801910:	90                   	nop
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	50                   	push   %eax
  801922:	6a 2f                	push   $0x2f
  801924:	e8 a4 f9 ff ff       	call   8012cd <syscall>
  801929:	83 c4 18             	add    $0x18,%esp

}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem,virtual_address, size,0,0,0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 30                	push   $0x30
  80193f:	e8 89 f9 ff ff       	call   8012cd <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem,virtual_address, size,0,0,0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 31                	push   $0x31
  80195b:	e8 6d f9 ff ff       	call   8012cd <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return;
  801963:	90                   	nop
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_get_hard_limit>:

uint32 sys_get_hard_limit(){
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_hard_limit,0,0,0,0,0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 32                	push   $0x32
  801975:	e8 53 f9 ff ff       	call   8012cd <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_env_set_nice>:

void sys_env_set_nice(int nice){
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_nice,nice,0,0,0,0);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 33                	push   $0x33
  801990:	e8 38 f9 ff ff       	call   8012cd <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019a7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	50                   	push   %eax
  8019af:	e8 d1 fa ff ff       	call   801485 <sys_cputc>
  8019b4:	83 c4 10             	add    $0x10,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019c0:	e8 8c fa ff ff       	call   801451 <sys_disable_interrupt>
	char c = ch;
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019cb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	50                   	push   %eax
  8019d3:	e8 ad fa ff ff       	call   801485 <sys_cputc>
  8019d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019db:	e8 8b fa ff ff       	call   80146b <sys_enable_interrupt>
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <getchar>:

int
getchar(void)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019f0:	eb 08                	jmp    8019fa <getchar+0x17>
	{
		c = sys_cgetc();
  8019f2:	e8 2a f9 ff ff       	call   801321 <sys_cgetc>
  8019f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019fe:	74 f2                	je     8019f2 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <atomic_getchar>:

int
atomic_getchar(void)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a0b:	e8 41 fa ff ff       	call   801451 <sys_disable_interrupt>
	int c=0;
  801a10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a17:	eb 08                	jmp    801a21 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a19:	e8 03 f9 ff ff       	call   801321 <sys_cgetc>
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a25:	74 f2                	je     801a19 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a27:	e8 3f fa ff ff       	call   80146b <sys_enable_interrupt>
	return c;
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <iscons>:

int iscons(int fdnum)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a34:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    
  801a3b:	90                   	nop

00801a3c <__udivdi3>:
  801a3c:	55                   	push   %ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 1c             	sub    $0x1c,%esp
  801a43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a53:	89 ca                	mov    %ecx,%edx
  801a55:	89 f8                	mov    %edi,%eax
  801a57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a5b:	85 f6                	test   %esi,%esi
  801a5d:	75 2d                	jne    801a8c <__udivdi3+0x50>
  801a5f:	39 cf                	cmp    %ecx,%edi
  801a61:	77 65                	ja     801ac8 <__udivdi3+0x8c>
  801a63:	89 fd                	mov    %edi,%ebp
  801a65:	85 ff                	test   %edi,%edi
  801a67:	75 0b                	jne    801a74 <__udivdi3+0x38>
  801a69:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6e:	31 d2                	xor    %edx,%edx
  801a70:	f7 f7                	div    %edi
  801a72:	89 c5                	mov    %eax,%ebp
  801a74:	31 d2                	xor    %edx,%edx
  801a76:	89 c8                	mov    %ecx,%eax
  801a78:	f7 f5                	div    %ebp
  801a7a:	89 c1                	mov    %eax,%ecx
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	f7 f5                	div    %ebp
  801a80:	89 cf                	mov    %ecx,%edi
  801a82:	89 fa                	mov    %edi,%edx
  801a84:	83 c4 1c             	add    $0x1c,%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5f                   	pop    %edi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    
  801a8c:	39 ce                	cmp    %ecx,%esi
  801a8e:	77 28                	ja     801ab8 <__udivdi3+0x7c>
  801a90:	0f bd fe             	bsr    %esi,%edi
  801a93:	83 f7 1f             	xor    $0x1f,%edi
  801a96:	75 40                	jne    801ad8 <__udivdi3+0x9c>
  801a98:	39 ce                	cmp    %ecx,%esi
  801a9a:	72 0a                	jb     801aa6 <__udivdi3+0x6a>
  801a9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa0:	0f 87 9e 00 00 00    	ja     801b44 <__udivdi3+0x108>
  801aa6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aab:	89 fa                	mov    %edi,%edx
  801aad:	83 c4 1c             	add    $0x1c,%esp
  801ab0:	5b                   	pop    %ebx
  801ab1:	5e                   	pop    %esi
  801ab2:	5f                   	pop    %edi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    
  801ab5:	8d 76 00             	lea    0x0(%esi),%esi
  801ab8:	31 ff                	xor    %edi,%edi
  801aba:	31 c0                	xor    %eax,%eax
  801abc:	89 fa                	mov    %edi,%edx
  801abe:	83 c4 1c             	add    $0x1c,%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5f                   	pop    %edi
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    
  801ac6:	66 90                	xchg   %ax,%ax
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	f7 f7                	div    %edi
  801acc:	31 ff                	xor    %edi,%edi
  801ace:	89 fa                	mov    %edi,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801add:	89 eb                	mov    %ebp,%ebx
  801adf:	29 fb                	sub    %edi,%ebx
  801ae1:	89 f9                	mov    %edi,%ecx
  801ae3:	d3 e6                	shl    %cl,%esi
  801ae5:	89 c5                	mov    %eax,%ebp
  801ae7:	88 d9                	mov    %bl,%cl
  801ae9:	d3 ed                	shr    %cl,%ebp
  801aeb:	89 e9                	mov    %ebp,%ecx
  801aed:	09 f1                	or     %esi,%ecx
  801aef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801af3:	89 f9                	mov    %edi,%ecx
  801af5:	d3 e0                	shl    %cl,%eax
  801af7:	89 c5                	mov    %eax,%ebp
  801af9:	89 d6                	mov    %edx,%esi
  801afb:	88 d9                	mov    %bl,%cl
  801afd:	d3 ee                	shr    %cl,%esi
  801aff:	89 f9                	mov    %edi,%ecx
  801b01:	d3 e2                	shl    %cl,%edx
  801b03:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b07:	88 d9                	mov    %bl,%cl
  801b09:	d3 e8                	shr    %cl,%eax
  801b0b:	09 c2                	or     %eax,%edx
  801b0d:	89 d0                	mov    %edx,%eax
  801b0f:	89 f2                	mov    %esi,%edx
  801b11:	f7 74 24 0c          	divl   0xc(%esp)
  801b15:	89 d6                	mov    %edx,%esi
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	f7 e5                	mul    %ebp
  801b1b:	39 d6                	cmp    %edx,%esi
  801b1d:	72 19                	jb     801b38 <__udivdi3+0xfc>
  801b1f:	74 0b                	je     801b2c <__udivdi3+0xf0>
  801b21:	89 d8                	mov    %ebx,%eax
  801b23:	31 ff                	xor    %edi,%edi
  801b25:	e9 58 ff ff ff       	jmp    801a82 <__udivdi3+0x46>
  801b2a:	66 90                	xchg   %ax,%ax
  801b2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b30:	89 f9                	mov    %edi,%ecx
  801b32:	d3 e2                	shl    %cl,%edx
  801b34:	39 c2                	cmp    %eax,%edx
  801b36:	73 e9                	jae    801b21 <__udivdi3+0xe5>
  801b38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b3b:	31 ff                	xor    %edi,%edi
  801b3d:	e9 40 ff ff ff       	jmp    801a82 <__udivdi3+0x46>
  801b42:	66 90                	xchg   %ax,%ax
  801b44:	31 c0                	xor    %eax,%eax
  801b46:	e9 37 ff ff ff       	jmp    801a82 <__udivdi3+0x46>
  801b4b:	90                   	nop

00801b4c <__umoddi3>:
  801b4c:	55                   	push   %ebp
  801b4d:	57                   	push   %edi
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 1c             	sub    $0x1c,%esp
  801b53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b57:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b6b:	89 f3                	mov    %esi,%ebx
  801b6d:	89 fa                	mov    %edi,%edx
  801b6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b73:	89 34 24             	mov    %esi,(%esp)
  801b76:	85 c0                	test   %eax,%eax
  801b78:	75 1a                	jne    801b94 <__umoddi3+0x48>
  801b7a:	39 f7                	cmp    %esi,%edi
  801b7c:	0f 86 a2 00 00 00    	jbe    801c24 <__umoddi3+0xd8>
  801b82:	89 c8                	mov    %ecx,%eax
  801b84:	89 f2                	mov    %esi,%edx
  801b86:	f7 f7                	div    %edi
  801b88:	89 d0                	mov    %edx,%eax
  801b8a:	31 d2                	xor    %edx,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	39 f0                	cmp    %esi,%eax
  801b96:	0f 87 ac 00 00 00    	ja     801c48 <__umoddi3+0xfc>
  801b9c:	0f bd e8             	bsr    %eax,%ebp
  801b9f:	83 f5 1f             	xor    $0x1f,%ebp
  801ba2:	0f 84 ac 00 00 00    	je     801c54 <__umoddi3+0x108>
  801ba8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bad:	29 ef                	sub    %ebp,%edi
  801baf:	89 fe                	mov    %edi,%esi
  801bb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb5:	89 e9                	mov    %ebp,%ecx
  801bb7:	d3 e0                	shl    %cl,%eax
  801bb9:	89 d7                	mov    %edx,%edi
  801bbb:	89 f1                	mov    %esi,%ecx
  801bbd:	d3 ef                	shr    %cl,%edi
  801bbf:	09 c7                	or     %eax,%edi
  801bc1:	89 e9                	mov    %ebp,%ecx
  801bc3:	d3 e2                	shl    %cl,%edx
  801bc5:	89 14 24             	mov    %edx,(%esp)
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	d3 e0                	shl    %cl,%eax
  801bcc:	89 c2                	mov    %eax,%edx
  801bce:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd2:	d3 e0                	shl    %cl,%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bdc:	89 f1                	mov    %esi,%ecx
  801bde:	d3 e8                	shr    %cl,%eax
  801be0:	09 d0                	or     %edx,%eax
  801be2:	d3 eb                	shr    %cl,%ebx
  801be4:	89 da                	mov    %ebx,%edx
  801be6:	f7 f7                	div    %edi
  801be8:	89 d3                	mov    %edx,%ebx
  801bea:	f7 24 24             	mull   (%esp)
  801bed:	89 c6                	mov    %eax,%esi
  801bef:	89 d1                	mov    %edx,%ecx
  801bf1:	39 d3                	cmp    %edx,%ebx
  801bf3:	0f 82 87 00 00 00    	jb     801c80 <__umoddi3+0x134>
  801bf9:	0f 84 91 00 00 00    	je     801c90 <__umoddi3+0x144>
  801bff:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c03:	29 f2                	sub    %esi,%edx
  801c05:	19 cb                	sbb    %ecx,%ebx
  801c07:	89 d8                	mov    %ebx,%eax
  801c09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c0d:	d3 e0                	shl    %cl,%eax
  801c0f:	89 e9                	mov    %ebp,%ecx
  801c11:	d3 ea                	shr    %cl,%edx
  801c13:	09 d0                	or     %edx,%eax
  801c15:	89 e9                	mov    %ebp,%ecx
  801c17:	d3 eb                	shr    %cl,%ebx
  801c19:	89 da                	mov    %ebx,%edx
  801c1b:	83 c4 1c             	add    $0x1c,%esp
  801c1e:	5b                   	pop    %ebx
  801c1f:	5e                   	pop    %esi
  801c20:	5f                   	pop    %edi
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    
  801c23:	90                   	nop
  801c24:	89 fd                	mov    %edi,%ebp
  801c26:	85 ff                	test   %edi,%edi
  801c28:	75 0b                	jne    801c35 <__umoddi3+0xe9>
  801c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2f:	31 d2                	xor    %edx,%edx
  801c31:	f7 f7                	div    %edi
  801c33:	89 c5                	mov    %eax,%ebp
  801c35:	89 f0                	mov    %esi,%eax
  801c37:	31 d2                	xor    %edx,%edx
  801c39:	f7 f5                	div    %ebp
  801c3b:	89 c8                	mov    %ecx,%eax
  801c3d:	f7 f5                	div    %ebp
  801c3f:	89 d0                	mov    %edx,%eax
  801c41:	e9 44 ff ff ff       	jmp    801b8a <__umoddi3+0x3e>
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	89 f2                	mov    %esi,%edx
  801c4c:	83 c4 1c             	add    $0x1c,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    
  801c54:	3b 04 24             	cmp    (%esp),%eax
  801c57:	72 06                	jb     801c5f <__umoddi3+0x113>
  801c59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c5d:	77 0f                	ja     801c6e <__umoddi3+0x122>
  801c5f:	89 f2                	mov    %esi,%edx
  801c61:	29 f9                	sub    %edi,%ecx
  801c63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c67:	89 14 24             	mov    %edx,(%esp)
  801c6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c72:	8b 14 24             	mov    (%esp),%edx
  801c75:	83 c4 1c             	add    $0x1c,%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5f                   	pop    %edi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
  801c7d:	8d 76 00             	lea    0x0(%esi),%esi
  801c80:	2b 04 24             	sub    (%esp),%eax
  801c83:	19 fa                	sbb    %edi,%edx
  801c85:	89 d1                	mov    %edx,%ecx
  801c87:	89 c6                	mov    %eax,%esi
  801c89:	e9 71 ff ff ff       	jmp    801bff <__umoddi3+0xb3>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c94:	72 ea                	jb     801c80 <__umoddi3+0x134>
  801c96:	89 d9                	mov    %ebx,%ecx
  801c98:	e9 62 ff ff ff       	jmp    801bff <__umoddi3+0xb3>
